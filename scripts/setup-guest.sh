#!/bin/bash
set -e

# Configuration du compte guest pour AgOS

if id "guest" >/dev/null 2>&1; then
  echo "L’utilisateur guest existe déjà."
else
  useradd -m -s /bin/bash -U guest
fi

printf 'guest:guest\n' | chpasswd
usermod -aG sudo guest

mkdir -p /home/guest/Desktop /home/guest/Documents /home/guest/Downloads /home/guest/Pictures
chown -R guest:guest /home/guest

printf 'root:root\n' | chpasswd

echo "Utilisateur guest prêt."
