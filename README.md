# AgOS — deux éditions

Le dépôt fournit deux profils :

| Édition | Usage | Commande |
|---|---|---|
| **Lite** | vieux PC, faible RAM, Internet, Wi‑Fi, navigateur et outils essentiels | `sudo ./build.sh amd64 lite` |
| **Full** | PC courant, bureautique, multimédia et développement | `sudo ./build.sh amd64 full` |

## AgOS Lite

XFCE allégé, Firefox ESR, NetworkManager, Wi‑Fi, Bluetooth, audio et outils système. Cette édition évite LibreOffice, les outils de développement lourds et les applications multimédias supplémentaires afin de réduire la taille et la consommation mémoire.

## AgOS Full

Ajoute LibreOffice, VLC, codecs FFmpeg, gestion audio, impression, GParted, Git, Python, Node.js, npm, compilateur et outils de développement.

## Construction locale

Sur Debian/Ubuntu 64 bits :

```bash
sudo apt update
sudo apt install -y git ca-certificates

git clone https://github.com/anassg80/AgOS.git
cd AgOS
chmod +x build.sh

# Vieux PC x86_64
sudo ./build.sh amd64 lite

# PC courant x86_64
sudo ./build.sh amd64 full
```

Les ISO et leurs empreintes SHA-256 sont placées dans `dist/`.

## Test

```bash
qemu-system-x86_64 -m 2048 -cdrom dist/AgOS-lite-amd64.iso
qemu-system-x86_64 -m 4096 -cdrom dist/AgOS-full-amd64.iso
```

Le compte Live est `guest` / `guest`. Après une installation permanente, change ce mot de passe immédiatement :

```bash
passwd
```

## ARM64

La commande `sudo ./build.sh arm64 lite` ou `sudo ./build.sh arm64 full` prépare un build Debian ARM64. L'image obtenue n'est pas automatiquement compatible avec chaque carte ARM : le noyau, le firmware et le bootloader varient selon le modèle. Pour Raspberry Pi, une image dédiée devra être ajoutée avec le firmware correspondant.

## GitHub Actions

Le workflow construit les deux éditions amd64 et publie les ISO comme artefacts de workflow. Les ISO peuvent aussi être construites localement pour ARM64.
