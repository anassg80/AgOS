# AgOS

AgOS est une distribution Linux personnalisée basée sur Debian, conçue pour être :
- stable et compatible avec les PC modernes
- légère avec XFCE
- installable sur disque
- personnalisable pour un usage bureautique / dev / multitâches
- compatible x86_64 de base, avec extension future pour ARM64

## Objectif

Crée une image ISO bootable à partir de Debian live-build, avec :
- utilisateur par défaut : guest
- bureau : XFCE
- gestionnaire de session : LightDM
- langue : français + anglais
- thème visuel personnalisé

## Architecture cible

- amd64 (PC standard)
- arm64 (support futur / Raspberry Pi / ARM64)

## Utilisation

### 1. Prérequis

Sur Debian/Ubuntu :

```bash
sudo apt update
sudo apt install -y git curl wget ca-certificates
```

### 2. Générer l’ISO

```bash
chmod +x build.sh
sudo ./build.sh amd64
```

Le résultat sera dans :

```bash
./build/result/
```

### 3. Créer une clé USB bootable

```bash
sudo dd if=./build/result/live-image-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Remplace `/dev/sdX` par le bon périphérique USB.

### 4. Tester dans QEMU

```bash
qemu-system-x86_64 -cdrom ./build/result/live-image-amd64.hybrid.iso -m 4096
```

## Structure du projet

```text
AgOS/
├── build.sh
├── LICENSE
├── README.md
├── .gitignore
├── config/
│   ├── hooks/
│   ├── includes.chroot/
│   └── package-lists/
├── scripts/
│   ├── install-agos.sh
│   └── setup-guest.sh
└── theme/
    └── README.md
```

## À venir

- génération ARM64 pour Raspberry Pi
- thème visuel complet AgOS
- ajout de logiciels bureautiques et de développement
- personnalisation du splash / fond d’écran / logo
- support d’installation automatique (preseed/autoinstall)

## Licence

MIT
