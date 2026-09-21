# AgOS

AgOS est une distribution Linux personnalisée basée sur Debian, conçue pour offrir un environnement stable, moderne et facilement installable sur PC classiques.

## Ce que contient le projet

- base Debian Bookworm stable
- environnement XFCE léger et fluide
- gestionnaire de session LightDM
- utilisateur `guest` créé par défaut
- langue française + anglais
- thème personnalisé AgOS
- support de build ISO live-build pour x86_64
- base pour support ARM64 / Raspberry Pi

## Fonctionnalités prévues

- ISO bootable pour PC x86_64
- installation sur disque via l’installateur Debian
- thème AgOS avec fond d’écran, palette visuelle et éléments personnalisés
- logiciels de bureau et de développement de base
- scripts de configuration automatique
- extension future vers ARM64 et versions plus complètes

## Prérequis

Sur Debian/Ubuntu :

```bash
sudo apt-get update
sudo apt-get install -y git curl wget ca-certificates imagemagick
```

## Génération de l’ISO

```bash
chmod +x build.sh
sudo ./build.sh amd64
```

Le fichier ISO sera produit dans :

```bash
./build/result/
```

## Création d’une clé USB bootable

```bash
sudo dd if=./build/result/live-image-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Remplace `/dev/sdX` par le bon périphérique.

## Test avec QEMU

```bash
qemu-system-x86_64 -cdrom ./build/result/live-image-amd64.hybrid.iso -m 4096
```

## Structure du dépôt

```text
AgOS/
├── .github/
│   └── workflows/
│       └── build.yml
├── build.sh
├── LICENSE
├── README.md
├── .gitignore
├── config/
│   ├── hooks/
│   │   └── 00-setup-guest.chroot
│   ├── includes.chroot/
│   │   ├── etc/
│   │   │   ├── hostname
│   │   │   ├── hosts
│   │   │   ├── lightdm/
│   │   │   │   └── lightdm.conf.d/
│   │   │   │       └── agos.conf
│   │   │   ├── profile.d/
│   │   │   │   └── agos.sh
│   │   │   └── skel/
│   │   │       ├── .bashrc
│   │   │       └── .config/
│   │   │           └── xfce4/
│   │   │               └── xfconf/
│   │   │                   └── xfce-perchannel-xml/
│   │   │                       └── xfce4-desktop.xml
│   │   └── usr/
│   │       └── share/
│   │           └── backgrounds/
│   │               └── agos-wallpaper.svg
│   └── package-lists/
│       └── agos.list.chroot
├── scripts/
│   ├── install-agos.sh
│   └── setup-guest.sh
├── theme/
│   ├── README.md
│   └── agos-logo.svg
└── build/
```

## Sécurité des comptes par défaut

Le projet utilise un compte utilisateur par défaut `guest` avec mot de passe `guest` uniquement dans le système de build initial. Tu peux ensuite le sécuriser lors de la personnalisation finale de l’image.

## Roadmap

- version x86_64 stable
- support ARM64
- amélioration du thème AgOS
- configuration de bureau renforcée
- splash screen personnalisé
- support de live install / autoinstall
- compatibilité pour anciens PC

## Licence

MIT
