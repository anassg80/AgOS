#!/bin/bash
set -e

ARCH="${1:-amd64}"

case "$ARCH" in
  amd64|arm64)
    ;;
  *)
    echo "Architecture non prise en charge : $ARCH"
    echo "Utilise : amd64 ou arm64"
    exit 1
    ;;
esac

if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté en root ou via sudo."
  echo "Exemple : sudo ./build.sh amd64"
  exit 1
fi

if ! command -v lb >/dev/null 2>&1; then
  echo "live-build n'est pas installé. Installation des dépendances..."
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
    grub-efi-arm64-bin \
    dosfstools \
    mtools \
    wget \
    curl \
    ca-certificates \
    git \
    imagemagick
fi

if [ "$ARCH" = "arm64" ] && ! command -v qemu-aarch64-static >/dev/null 2>&1; then
  echo "Installation de qemu-user-static pour l’architecture ARM64..."
  apt-get install -y qemu-user-static
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

mkdir -p config/includes.chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
mkdir -p config/includes.chroot/etc/profile.d
mkdir -p config/includes.chroot/etc/lightdm/lightdm.conf.d
mkdir -p config/includes.chroot/usr/share/backgrounds

# Fond d’écran par défaut AgOS
if [ ! -f ../config/includes.chroot/usr/share/backgrounds/agos-wallpaper.svg ]; then
  echo "Aucun fond d'écran n'a été trouvé. Création du fond d’écran AgOS..."
fi

# Vérifie que le fond est présent et le copie dans les fichiers de build
if [ -f ../config/includes.chroot/usr/share/backgrounds/agos-wallpaper.svg ]; then
  cp ../config/includes.chroot/usr/share/backgrounds/agos-wallpaper.svg \
    config/includes.chroot/usr/share/backgrounds/agos-wallpaper.svg
fi

# Fichier de config par défaut XFCE
cat > config/includes.chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty"/>
  <property name="desktop-icons" type="empty"/>
  <property name="last" type="empty"/>
</channel>
EOF

# Fichier de configuration pour présenter AgOS
cat > config/includes.chroot/etc/profile.d/agos.sh <<'EOF'
#!/bin/bash

echo "Bienvenue sur AgOS"
echo "Distribution Debian personnalisée"
echo "Utilisateur par défaut : guest"
echo "Mot de passe : guest (à sécuriser après installation)"
echo
EOF
chmod +x config/includes.chroot/etc/profile.d/agos.sh

# LightDM : autologin guest pour le live session
cat > config/includes.chroot/etc/lightdm/lightdm.conf.d/agos.conf <<'EOF'
[Seat:*]
user-session=xfce
autologin-user=guest
autologin-user-timeout=0
greeter-show-manual-login=true
greeter-hide-users=false
EOF

# Fichier d’accueil utilisateur bash
cat > config/includes.chroot/etc/skel/.bashrc <<'EOF'
# ~/.bashrc

export PS1="\[\e[32m\][\u@\h \W]\$\[\e[0m\] "
export LANG=fr_FR.UTF-8
export LANGUAGE=fr_FR:fr:en_US:en

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'

neofetch 2>/dev/null || true
EOF

echo "Construction de l’image AgOS pour $ARCH..."
lb build

echo
echo "ISO produite dans : ./build/result/"
ls -lh result || true
