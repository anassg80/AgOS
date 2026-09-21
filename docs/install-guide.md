# Guide d’installation AgOS

Ce guide couvre l’installation d’AgOS à partir des images ISO générées par le projet.

## 1. Choisir la bonne édition

### AgOS Lite

À choisir si ton PC est ancien ou si tu veux un système rapide et léger.

- vieux PC ou machine modeste
- usage léger
- navigation web
- Wi‑Fi, Ethernet et audio
- outils minimaux

### AgOS Full

À choisir si tu veux un système plus complet.

- développement
- bureautique
- multimédia
- codecs
- impression
- outils de système

## 2. Télécharger la bonne image

Télécharge l’image correspondante depuis la release GitHub ou depuis le dossier `dist/` local.

### Versions amd64

- AgOS-lite-amd64.iso
- AgOS-full-amd64.iso

### Versions arm64

- AgOS-lite-arm64.iso
- AgOS-full-arm64.iso

## 3. Créer une clé USB bootable

Sous Linux :

```bash
sudo dd if=AgOS-full-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Remplace `/dev/sdX` par la clé USB cible.

## 4. Démarrer sur la clé USB

1. Branche la clé USB.
2. Redémarre le PC.
3. Entre dans le boot menu ou le BIOS/UEFI.
4. Sélectionne la clé USB.
5. Démarre sur AgOS.

## 5. Tester le système live

Le système live démarre avec :

- utilisateur : `guest`
- mot de passe : `guest`

Tu peux tester le système avant d’installer.

## 6. Installer AgOS sur le disque

1. Démarre depuis l’ISO.
2. Ouvre l’installateur Debian proposé.
3. Choisis la langue.
4. Choisis le disque de destination.
5. Configure le mot de passe root et le compte utilisateur.
6. Installe le système.
7. Redémarre.

## 7. Sécuriser la machine installée

Après installation, passe par le compte utilisateur principal et change le mot de passe système :

```bash
passwd
```

Pour mettre à jour le système :

```bash
sudo apt update
sudo apt full-upgrade
```

## 8. Rename du système

Tu peux configurer le nom de machine :

```bash
sudo hostnamectl set-hostname agos
```

## 9. Compatibilité ARM64

Les images ARM64 ne fonctionnent pas automatiquement sur toutes les cartes. Leur boot dépend du modèle exact, du firmware et du bootloader. 

Pour Raspberry Pi ou autres cartes ARM, il faudra vérifier le support du matériel ciblé :

- modèle exact de la carte
- firmware disponible
- bootloader compatible
- support du noyau Linux

## 10. Problèmes courants

### Pas de démarrage depuis la clé USB

- vérifie le mode boot : UEFI ou BIOS
- récrée la clé USB avec `dd`
- vérifie la vérification du fichier ISO

### Pas de Wi‑Fi

- vérifie que le bon firmware est installé
- utilise une édition récente du système
- vérifie les pilotes du matériel

### Pas de son

- vérifie les paramètres audio
- ouvre le gestionnaire audio PulseAudio/PavuControl
- vérifie que le bon périphérique est sélectionné

## 11. Versions recommandées

- pour ancien PC : `AgOS Lite amd64`
- pour PC de bureau moderne : `AgOS Full amd64`
- pour ARM64 léger : `AgOS Lite arm64`
- pour ARM64 complet : `AgOS Full arm64`

## 12. Remarque importante

Le projet AgOS est un système Linux. Les fichiers de release sont des images Linux (`.iso`), pas des applications Android/iOS/macOS (`.apk`, `.ipa`).
