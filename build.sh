#!/bin/bash
set -e

ARCH="${1:-amd64}"

if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté en root ou via sudo."
  echo "Exemple : sudo ./build.sh amd64"
  exit 1
fi

if ! command -v lb >/dev/null 2>&1; then
  echo "live-build n'est pas installé. Installation en cours..."
  apt-get update
  apt-get install -y \
    live-build \
    debootstrap \
    squashfs-tools \
    xorriso \
    syslinux \
    syslinux-utils \
    isolinux \
    grub-pc-bin \
    grub-efi-amd64-bin \
    dosfstools \
    mtools \
    wget \
    curl \
    ca-certificates \
    git
fi

echo "Architecture cible : $ARCH"

echo "Nettoyage du dossier précédent..."
rm -rf ./build
mkdir -p ./build
cd ./build

lb config \
  --distribution bookworm \
  --binary-images iso-hybrid \
  --architectures "$ARCH" \
  --debian-installer false \
  --archive-areas "main contrib non-free non-free-firmware" \
  --mirror-bootstrap "http://deb.debian.org/debian" \
  --mirror-binary "http://deb.debian.org/debian" \
  --mirror-chroot "http://deb.debian.org/debian" \
  --mirror-chroot-security "http://deb.debian.org/debian-security" \
  --mirror-binary-security "http://deb.debian.org/debian-security" \
  --bootappend-live "boot=live components splash username=guest" \
  --bootappend-live-failsafe "boot=live components memtest"

cp -r ../config ./

mkdir -p config/includes.chroot/etc/skel
mkdir -p config/includes.chroot/etc/profile.d
mkdir -p config/includes.chroot/etc/lightdm/lightdm.conf.d
mkdir -p config/includes.chroot/usr/share/backgrounds

# Prépare un fichier d’exemple pour le fond d’écran
if [ ! -f config/includes.chroot/usr/share/backgrounds/agos-wallpaper.png ]; then
  mkdir -p config/includes.chroot/usr/share/backgrounds
  convert -size 1920x1080 xc:'#111827' -fill '#00B7FF' -draw "circle 850,420 850,120" /tmp/agos-wallpaper.png 2>/dev/null || true
  if [ -f /tmp/agos-wallpaper.png ]; then
    cp /tmp/agos-wallpaper.png config/includes.chroot/usr/share/backgrounds/agos-wallpaper.png
  fi
fi

echo "Construction de l’image AgOS..."
lb build

echo
echo "ISO produite dans : ./build/result/"
echo "Fichiers générés :"
ls -lh result || true
