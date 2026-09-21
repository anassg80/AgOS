# AgOS Lite et Full

Le dépôt contient quatre éditions distinctes :

- **Lite amd64** : anciens PC x86_64, avec Internet, Wi-Fi, Ethernet, navigateur, audio et Bluetooth.
- **Full amd64** : PC x86_64 courants, avec bureautique, multimédia, impression et développement.
- **Lite arm64** : même sélection légère pour appareils ARM64.
- **Full arm64** : sélection complète pour appareils ARM64.

## Lite reste Lite

AgOS Lite ne contient volontairement pas :

- LibreOffice
- VLC et logiciels multimédia supplémentaires
- outils de compilation
- Python/pip, Node.js/npm
- outils d’impression
- Synaptic et outils de développement lourds

Elle conserve cependant les éléments essentiels :

- XFCE et LightDM
- Firefox ESR
- NetworkManager et Wi-Fi
- firmwares Wi-Fi courants
- Bluetooth et audio
- gestionnaire de fichiers et terminal
- outils système de base

## Construire

```bash
chmod +x build.sh scripts/check-project.sh
./scripts/check-project.sh

sudo ./build.sh amd64 lite
sudo ./build.sh amd64 full
sudo ./build.sh arm64 lite
sudo ./build.sh arm64 full
```

Les fichiers sont produits dans `dist/`, avec un fichier SHA-256 associé.

## Compatibilité ARM64

Une image ARM64 générique Debian n’est pas automatiquement une image Raspberry Pi : les firmwares, le noyau et le bootloader dépendent de la carte. Les builds ARM64 sont donc conservés et générés, mais il faut cibler le modèle exact pour garantir le démarrage sur le matériel.

## Après installation

Le compte Live par défaut est `guest` / `guest`. Sur une installation permanente, change immédiatement le mot de passe :

```bash
passwd
```

Puis mets à jour le système :

```bash
sudo apt update
sudo apt full-upgrade
```
