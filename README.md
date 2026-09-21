# AgOS

AgOS est une distribution Linux personnalisée basée sur Debian, avec deux profils principaux :

- Lite : à la fois léger et connecté à Internet
- Full : bureau complet, multimédia et développement

## Éditions disponibles

- AgOS Lite amd64
- AgOS Full amd64
- AgOS Lite arm64
- AgOS Full arm64

## Release GitHub

Le dépôt contient un workflow `release.yml` qui, à partir d'un tag ou d'un déclenchement manuel, construit les 4 images Linux et les téléverse dans une GitHub Release.

Les formats de publication de la release concernent le système Linux :

- ISO pour PC amd64
- ISO/IMG pour ARM64 selon le matériel cible

Les formats `.apk` / `.ipa` ne sont pas des images système Linux et sont donc documentés comme projets séparés dans `apps/`.
