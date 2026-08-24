Pokemon Gamma emeraude-Patch Fr Version 1.13

disponible maintenant

https://github.com/user-attachments/assets/54bc4629-5bf2-4b65-91c3-a32e52b05624


# Pokémon Gamma Emerald — Patch Français

## Traduction française non officielle

Le patch français permet de jouer à **Pokémon Gamma Emerald** en français.

> Le projet est autorisé par le développeur UndreamedPanic.

---

# Installation — Windows

## 1. Télécharger le patch pour la version 1.13.1 minimum

Téléchargez la dernière version du patch français et extrayez entièrement l'archive.

## 2. Ouvrir le dossier du jeu

Ouvrez le dossier d'installation de **Pokémon Gamma Emerald**, celui qui contient notamment :

```text
PokemonEmerald.exe
```

## 3. Installer le patch

Suivez les instructions correspondant aux fichiers présents dans la version du patch téléchargée.
Il y a juste besoin de copier le dossier PokemonEmerald, et les 2 fichiers .BAT (JOUER EN ANGLAIS.BAT / JOUER EN FRANCAIS.BAT) dans le dossier principal de Pokemon Gamma.

Une vidéo d'installation est disponible ci-dessous :


## 4. Lancer le jeu en français

Après l'installation, lancez normalement le jeu.

Si le jeu reste en anglais, ajoutez l'argument suivant dans les options de lancement :

```text
-culture=fr
```

Respectez exactement cette écriture, sans espace.

---

===============================================================================

# Installation — Linux

Compatible avec différentes distributions et méthodes de lancement, notamment :

- Bazzite
- SteamOS
- Fedora
- Arch
- Faugus
- Lutris
- Heroic
- Bottles
- Steam / Proton

## 1. Télécharger et extraire le patch pour la version 1.13.1 minimum

Téléchargez la dernière version du patch français et extrayez entièrement l'archive.

## 2. Placer le dossier du patch

Placez le dossier extrait du patch dans le dossier racine de **Pokémon Gamma Emerald**, à côté de :

```text
PokemonEmerald.exe
```

Ne placez pas le dossier dans :

```text
PokemonEmerald/Binaries/Win64
```

## 3. Lancer l'installation

Ouvrez le dossier extrait du patch.

Faites un clic droit dans le dossier puis sélectionnez :

```text
Ouvrir un terminal ici
```

Dans le terminal, exécutez :

```bash
bash installer-fr.sh
```

Le script recherche le jeu, installe la traduction et configure automatiquement la langue française.

## Si le jeu n'est pas trouvé

Indiquez manuellement le chemin du dossier contenant `PokemonEmerald.exe` :

```bash
bash installer-fr.sh /chemin/vers/Pokemon-Gamma-Emerald
```

Avec Faugus, vous pouvez retrouver le chemin du jeu avec :

```text
Clic droit sur le jeu > Edit
```

Le champ situé en haut indique le chemin utilisé.

## Lancer le jeu en français

Après l'installation, lancez normalement le jeu depuis votre launcher ou raccourci avec Faugus ou autre launcher.

le script configure automatiquement la langue française, il faut ajouter l'argument dans Faugus/Lutris/Heroic/Steam

Si le jeu reste en anglais, ajoutez :

```text
-culture=fr
```

### Faugus

```text
Clic droit sur le jeu > Edit > Arguments du jeu
```

### Lutris

```text
Configurer > Options du jeu > Arguments
```

### Heroic

```text
Paramètres du jeu > Arguments avancés
```

### Steam

Dans les options de lancement :

```text
%command% -culture=fr
```

---

# Désinstallation — Linux

Pour supprimer le patch, ouvrez un terminal dans le dossier du patch et exécutez :

```bash
bash desinstaller-fr.sh
```

Cela supprime la traduction et restaure la configuration précédente.

bash desinstaller-fr.sh


