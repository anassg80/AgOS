#!/usr/bin/env bash
set -Eeuo pipefail

ARCH="${1:-amd64}"
PROFILE="${2:-full}"

[[ "$ARCH" == "amd64" || "$ARCH" == "arm64" ]] || { echo "Architecture invalide: $ARCH" >&2; exit 2; }
[[ "$PROFILE" == "lite" || "$PROFILE" == "full" ]] || { echo "Profil invalide: $PROFILE" >&2; exit 2; }
[[ $EUID -eq 0 ]] || { echo "Utilise: sudo ./build.sh $ARCH $PROFILE" >&2; exit 1; }

export DEBIAN_FRONTEND=noninteractive
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$ROOT_DIR/build/${ARCH}-${PROFILE}"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

command -v lb >/dev/null
command -v debootstrap >/dev/null
command -v xorriso >/dev/null
command -v mksquashfs >/dev/null

NATIVE_ARCH="$(dpkg --print-architecture)"
[[ "$NATIVE_ARCH" == "$ARCH" ]] || {
  echo "Le build doit être natif: runner=$NATIVE_ARCH, cible=$ARCH" >&2
  exit 1
}

BINARY_IMAGES="iso-hybrid"
[[ "$ARCH" == "arm64" ]] && BINARY_IMAGES="iso"

lb config \
  --distribution bookworm \
  --binary-images "$BINARY_IMAGES" \
  --architectures "$ARCH" \
  --debian-installer live \
  --archive-areas "main contrib non-free non-free-firmware" \
  --keyring-packages debian-archive-keyring \
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
