#!/bin/bash
set -e

# Installation minimale de base sur une machine Debian réelle
# Peut être utilisée pour installer les outils nécessaires ou recommencer un système

apt-get update
apt-get install -y \
  task-xfce-desktop \
  lightdm \
  network-manager \
  network-manager-gnome \
  firefox-esr \
  vim \
  curl \
  wget \
  git \
  sudo \
  ca-certificates \
  htop \
  neofetch \
  fonts-dejavu-core \
  pulseaudio \
  pavucontrol \
  alsa-utils \
  bluetooth \
  blueman \
  gparted \
  gnome-terminal

systemctl enable lightdm
systemctl enable NetworkManager

echo "Installation AgOS terminée."
