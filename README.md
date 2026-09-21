# AgOS — quatre éditions

Les quatre éditions sont disponibles sans supprimer les versions existantes :

| Édition | Usage | Commande |
|---|---|---|
| **Lite amd64** | vieux PC x86_64 | `sudo ./build.sh amd64 lite` |
| **Full amd64** | PC x86_64 courant | `sudo ./build.sh amd64 full` |
| **Lite arm64** | appareil ARM64 peu puissant | `sudo ./build.sh arm64 lite` |
| **Full arm64** | appareil ARM64 plus puissant | `sudo ./build.sh arm64 full` |

## Versions ARM64

Les deux profils ARM64 utilisent exactement les mêmes logiciels de base que leurs équivalents amd64 :

- **AgOS Lite ARM64** : XFCE, NetworkManager, Wi-Fi, Bluetooth, audio, Firefox ESR et outils essentiels.
- **AgOS Full ARM64** : Lite plus LibreOffice, VLC, codecs FFmpeg, impression, GParted et outils de développement.

La commande ARM64 doit être exécutée sur une machine Debian/Ubuntu compatible avec le build. `live-build` produit une image Debian ARM64, mais le démarrage dépend de la carte : un Raspberry Pi, une carte ARM générique et un PC ARM peuvent nécessiter des firmwares, noyaux ou bootloaders différents.

Pour Raspberry Pi, cette première version est donc une base ARM64 générique ; une prochaine étape pourra ajouter une image dédiée au modèle exact de ta carte.

## Construire les quatre versions

```bash
chmod +x build.sh
sudo ./build.sh amd64 lite
sudo ./build.sh amd64 full
sudo ./build.sh arm64 lite
sudo ./build.sh arm64 full
```

Les fichiers sont placés dans `dist/` :

```text
dist/AgOS-lite-amd64.iso
dist/AgOS-full-amd64.iso
dist/AgOS-lite-arm64.iso
dist/AgOS-full-arm64.iso
```

Chaque ISO possède aussi un fichier `.sha256`.

## GitHub Actions

Le workflow construit maintenant les quatre combinaisons en parallèle :

- amd64 + lite
- amd64 + full
- arm64 + lite
- arm64 + full

Les fichiers sont disponibles dans les artefacts de l’exécution GitHub Actions. Les builds ARM64 peuvent prendre davantage de temps et leur compatibilité de démarrage doit être vérifiée sur le matériel cible.
