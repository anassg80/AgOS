# AgOS release packages

Les fichiers Linux suivants sont destinés à une publication dans une release GitHub :

- AgOS-lite-amd64.iso
- AgOS-full-amd64.iso
- AgOS-lite-arm64.iso
- AgOS-full-arm64.iso

Les fichiers `.sha256` sont également générés automatiquement pour vérifier les intégrités.

## Catégories de publication

### 1) Systèmes Linux PC
- `amd64` : PC Intel/AMD classiques
- `arm64` : cartes ARM64 et plateformes compatibles

### 2) Éditions AgOS
- `lite` : minimaliste, sans bloat, avec Internet et Wi‑Fi
- `full` : bureau complet, multimédia, bureautique et dev

## Remarque importante

Les formats `.apk`, `.ipa` et `.app` ne sont pas des images du système Linux. Ce sont des applications mobiles distinctes. AgOS est un système Linux, donc le bon format de publication est ISO/IMG pour PC et ARM64.

Les dossiers dans `apps/` servent de base pour une future extension vers Android, iOS et macOS, mais ils ne remplacent pas les images Linux de la release.
