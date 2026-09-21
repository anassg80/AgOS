#!/usr/bin/env bash
set -Eeuo pipefail

ARCH="${1:-amd64}"
PROFILE="${2:-full}"

[[ "$ARCH" == "amd64" || "$ARCH" == "arm64" ]] || { echo "Architecture invalide: $ARCH" >&2; exit 2; }
[[ "$PROFILE" == "lite" || "$PROFILE" == "full" ]] || { echo "Profil invalide: $PROFILE" >&2; exit 2; }
[[ $EUID -eq 0 ]] || { echo "Utilise: sudo ./build.sh $ARCH $PROFILE" >&2; exit 1; }

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y live-build debootstrap squashfs-tools xorriso syslinux syslinux-utils isolinux grub-pc-bin grub-efi-amd64-bin dosfstools mtools ca-certificates curl git qemu-user-static

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$ROOT_DIR/build/${ARCH}-${PROFILE}"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# iso-hybrid est adapté aux PC amd64. Pour ARM64, on produit une ISO classique :
# le bootloader/firmware dépend de la carte ARM ciblée.
BINARY_IMAGES="iso-hybrid"
[[ "$ARCH" == "arm64" ]] && BINARY_IMAGES="iso"

lb config \
  --distribution bookworm \
  --binary-images "$BINARY_IMAGES" \
  --architectures "$ARCH" \
  --debian-installer live \
  --archive-areas "main contrib non-free non-free-firmware" \
  --mirror-bootstrap "https://deb.debian.org/debian" \
  --mirror-binary "https://deb.debian.org/debian" \
  --mirror-chroot "https://deb.debian.org/debian" \
  --mirror-chroot-security "https://deb.debian.org/debian-security" \
  --mirror-binary-security "https://deb.debian.org/debian-security" \
  --bootappend-live "boot=live components username=guest locales=fr_FR.UTF-8,en_US.UTF-8"

mkdir -p config
cp -a "$ROOT_DIR/config/." config/
rm -f config/package-lists/*.list.chroot
cp "$ROOT_DIR/config/package-lists/agos-${PROFILE}.list.chroot" config/package-lists/agos.list.chroot
mkdir -p config/includes.chroot/etc
printf '%s\n' "$PROFILE" > config/includes.chroot/etc/agos-profile
printf '%s\n' "$ARCH" > config/includes.chroot/etc/agos-architecture

lb build
mkdir -p "$ROOT_DIR/dist"
OUTPUT="$(find . -maxdepth 1 -type f \( -name '*.iso' -o -name '*.img' \) -print -quit)"
[[ -n "$OUTPUT" ]] || { echo "Aucune image produite pour $ARCH/$PROFILE" >&2; exit 1; }
FINAL="$ROOT_DIR/dist/AgOS-${PROFILE}-${ARCH}.iso"
cp "$OUTPUT" "$FINAL"
sha256sum "$FINAL" > "$FINAL.sha256"
echo "Image créée: $FINAL"
