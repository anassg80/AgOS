#!/usr/bin/env bash
set -Eeuo pipefail

ARCH="${1:-amd64}"
PROFILE="${2:-full}"

[[ "$ARCH" == "amd64" || "$ARCH" == "arm64" ]] || { echo "Architecture invalide: $ARCH" >&2; exit 2; }
[[ "$PROFILE" == "lite" || "$PROFILE" == "full" ]] || { echo "Profil invalide: $PROFILE" >&2; exit 2; }
[[ $EUID -eq 0 ]] || { echo "Le build doit être lancé avec sudo" >&2; exit 1; }

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$ROOT_DIR/build/${ARCH}-${PROFILE}"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

for tool in lb debootstrap xorriso mksquashfs; do
  command -v "$tool" >/dev/null || { echo "Outil manquant: $tool" >&2; exit 1; }
done

BINARY_IMAGES="iso-hybrid"
LB_EXTRA=()
if [[ "$ARCH" == "arm64" ]]; then
  BINARY_IMAGES="iso"
  QEMU_STATIC=/usr/bin/qemu-aarch64-static
  [[ -x "$QEMU_STATIC" ]] || { echo "QEMU ARM64 manquant" >&2; exit 1; }
  LB_EXTRA+=(--bootstrap-qemu-arch arm64 --bootstrap-qemu-static "$QEMU_STATIC")
fi

lb config \
  --distribution bookworm \
  --binary-images "$BINARY_IMAGES" \
  --architectures "$ARCH" \
  --debian-installer live \
  --archive-areas "main contrib non-free non-free-firmware" \
  --keyring-packages debian-archive-keyring \
  --mirror-bootstrap https://deb.debian.org/debian \
  --mirror-binary https://deb.debian.org/debian \
  --mirror-chroot https://deb.debian.org/debian \
  --mirror-chroot-security https://deb.debian.org/debian-security \
  --mirror-binary-security https://deb.debian.org/debian-security \
  --bootappend-live "boot=live components username=guest locales=fr_FR.UTF-8,en_US.UTF-8" \
  "${LB_EXTRA[@]}"

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
