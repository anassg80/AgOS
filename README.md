# AgOS

AgOS est une distribution Linux personnalisée basée sur Debian, conçue pour fonctionner sur PC classiques et sur plateformes ARM64 compatibles.

## Vue d’ensemble

AgOS propose quatre éditions distinctes, sans supprimer les versions précédentes :

- AgOS Lite amd64
- AgOS Full amd64
- AgOS Lite arm64
- AgOS Full arm64

Les deux profils sont conçus pour rester cohérents :

- Lite : légère, rapide, prête à l’usage sur anciens PC, avec Internet, Wi‑Fi, audio et navigateur.
- Full : bureau complet, bureautique, multimédia, codecs, impression, développement et outils système plus larges.

## Versions disponibles

### AgOS Lite

Profil léger et fonctionnel :

- Xfce
- LightDM
- NetworkManager
- Firefox ESR
- Bluetooth
- audio
- outils système essentiels
- connexion Internet et Wi‑Fi

Idéal pour anciens ordinateurs, machines modestes et setups minimalistes.

### AgOS Full

Profil complet :

- Xfce
- Suite bureautique (LibreOffice)
- VLC et codecs multimédias
- développement (Git, Python, Node.js, npm, build tools)
- outils système et gestion de disque
- impression, GParted, Synaptic

Idéal pour utilisation quotidienne, travail, développement et multimédia.

## Architecture supportée

- amd64 (PC Intel/AMD classiques)
- arm64 (firmware et cartes ARM64 compatibles)

## Construction locale

Prérequis sur Debian/Ubuntu :

```bash
sudo apt update
sudo apt install -y git ca-certificates curl wget
```

Puis :

```bash
git clone https://github.com/anassg80/AgOS.git
cd AgOS
chmod +x build.sh
```

### Construire une édition

```bash
sudo ./build.sh amd64 lite
sudo ./build.sh amd64 full
sudo ./build.sh arm64 lite
sudo ./build.sh arm64 full
```

Les images sont générées dans le dossier `dist/`.

## Fichiers générés

Chaque build produit :

- une image ISO Linux
- un fichier SHA-256 de vérification

Exemple :

```text
dist/
├── AgOS-lite-amd64.iso
├── AgOS-lite-amd64.iso.sha256
├── AgOS-full-amd64.iso
├── AgOS-full-amd64.iso.sha256
├── AgOS-lite-arm64.iso
├── AgOS-lite-arm64.iso.sha256
├── AgOS-full-arm64.iso
├── AgOS-full-arm64.iso.sha256
```

## Test en machine virtuelle

QEMU :

```bash
qemu-system-x86_64 -m 2048 -cdrom dist/AgOS-full-amd64.iso
```

## Clé USB bootable

```bash
sudo dd if=dist/AgOS-full-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Remplace `/dev/sdX` par la bonne clé USB.

## Comptes de départ

Le compte live par défaut est :

- utilisateur : `guest`
- mot de passe : `guest`

À utiliser seulement dans la session live ou dans l’état de build initial. Sur une installation permanente, change le mot de passe immédiatement.

```bash
passwd
```

## Release GitHub

Le dépôt contient un workflow de release complet pour publier automatiquement les 4 images Linux dans une GitHub Release.

Le workflow vérifie automatiquement les images produites et publie les fichiers `.iso` ainsi que leurs hashes SHA-256.

## Attention importante

AgOS est un système Linux. Les formats `.apk`, `.ipa` et `.app` ne remplacent pas une image système bootable.

Les fichiers de publication restent donc des images Linux au format ISO, adaptées à l’architecture cible.

Les dossiers `apps/android`, `apps/ios` et `apps/macos` sont des bases de travail pour de futures applications de companion, mais ne remplacent pas la release Linux principale.

## Structure du dépôt

```text
AgOS/
├── .github/
│   ├── workflows/
│   │   ├── build.yml
│   │   ├── release.yml
│   │   └── validate.yml
├── apps/
│   ├── android/
│   ├── ios/
│   └── macos/
├── build.sh
├── config/
│   ├── hooks/
│   ├── includes.chroot/
│   └── package-lists/
├── docs/
│   ├── install-guide.md
│   └── release-packages.md
├── scripts/
│   ├── check-project.sh
│   ├── install-agos.sh
│   └── setup-guest.sh
├── theme/
│   ├── agos-logo.svg
│   └── README.md
├── LICENSE
├── README.md
├── .gitignore
└── dist/
```

## Licence

MIT
