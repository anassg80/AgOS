#!/bin/bash
set -e

# Préparation du compte guest pour AgOS
# À exécuter dans le chroot du système live-build

if id "guest" >/dev/null 2>&1; then
  echo "L’utilisateur guest existe déjà."
else
  useradd -m -s /bin/bash -U guest
fi

printf 'guest:guest\n' | chpasswd
usermod -aG sudo guest

mkdir -p /home/guest/Desktop /home/guest/Documents /home/guest/Downloads /home/guest/Pictures
chown -R guest:guest /home/guest

# Mot de passe root (à ajuster selon le besoin du projet)
printf 'root:root\n' | chpasswd

echo "Utilisateur guest prêt."
