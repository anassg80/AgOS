#!/usr/bin/env bash
set -Eeuo pipefail

ARCH="${1:-amd64}"
PROFILE="${2:-full}"

if [[ "$ARCH" != "amd64" && "$ARCH" != "arm64" ]]; then
  echo "Architecture invalide : $ARCH (utilise amd64 ou arm64)" >&2
  exit 2
fi

if [[ "$PROFILE" != "lite" && "$PROFILE" != "full" ]]; then
  echo "Profil invalide : $PROFILE (utilise lite ou full)" >&2
  exit 2
fi

if [[ $EUID -ne 0 ]]; then
  echo "Lance ce script avec sudo : sudo ./build.sh arm64 lite" >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

if ! command -v lb >/dev/null 2>&1; then
  apt-get update
  apt-get install -y \
    live-build debootstrap squashfs-tools xorriso syslinux syslinux-utils \
    isolinux grub-pc-bin grub-efi-amd64-bin grub-efi-arm64-bin dosfstools \
    mtools ca-certificates curl git qemu-user-static
fi

if [[ "$ARCH" == "arm64" ]] && ! command -v qemu-aarch64-static >/dev/null 2>&1; then
  apt-get update
  apt-get install -y qemu-user-static
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$ROOT_DIR/build/${ARCH}-${PROFILE}"

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Un environnement de build indépendant est utilisé pour chaque combinaison.
lb config \
  --distribution bookworm \
  --binary-images iso-hybrid \
  --architectures "$ARCH" \
  --debian-installer live \
  --archive-areas "main contrib non-free non-free-firmware" \
  --mirror-bootstrap "https://deb.debian.org/debian" \
  --mirror-binary "https://deb.debian.org/debian" \
  --mirror-chroot "https://deb.debian.org/debian" \
  --mirror-chroot-security "https://deb.debian.org/debian-security" \
  --mirror-binary-security "https://deb.debian.org/debian-security" \
  --bootappend-live "boot=live components username=guest locales=fr_FR.UTF-8,en_US.UTF-8" \
  --bootappend-live-failsafe "boot=live components"

mkdir -p config
cp -a "$ROOT_DIR/config/." config/
rm -f config/package-lists/*.list.chroot
cp "$ROOT_DIR/config/package-lists/agos-${PROFILE}.list.chroot" \
  config/package-lists/agos.list.chroot

mkdir -p config/includes.chroot/etc
printf '%s\n' "$PROFILE" > config/includes.chroot/etc/agos-profile
printf '%s\n' "$ARCH" > config/includes.chroot/etc/agos-architecture

lb build

mkdir -p "$ROOT_DIR/dist"
OUTPUT="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "$OUTPUT" ]]; then
  echo "Aucune ISO n'a été produite pour $ARCH/$PROFILE." >&2
  exit 1
fi

FINAL="$ROOT_DIR/dist/AgOS-${PROFILE}-${ARCH}.iso"
cp "$OUTPUT" "$FINAL"
sha256sum "$FINAL" > "$FINAL.sha256"

echo "ISO créée : $FINAL"
echo "Empreinte : $FINAL.sha256"
