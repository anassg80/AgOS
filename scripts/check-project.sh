#!/bin/bash
set -Eeuo pipefail

# Vérification locale simple avant de lancer live-build.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for file in \
  "$ROOT_DIR/build.sh" \
  "$ROOT_DIR/config/package-lists/agos-lite.list.chroot" \
  "$ROOT_DIR/config/package-lists/agos-full.list.chroot"; do
  [[ -f "$file" ]] || { echo "Fichier manquant : $file" >&2; exit 1; }
done

for command in bash grep find; do
  command -v "$command" >/dev/null || { echo "Commande manquante : $command" >&2; exit 1; }
done

echo "Configuration AgOS valide."
