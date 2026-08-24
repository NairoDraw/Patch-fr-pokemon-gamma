# Pour un autre Claude — traduction FR de Pokémon Gamma Emerald

État au **24 août 2026**. Remplace la version du 22 août, archivée dans
`_historique/POUR-UN-AUTRE-CLAUDE-2026-08-22.md` — elle garde le détail des
pistes explorées et abandonnées si tu en as besoin.

Lis ce document en entier avant de toucher à quoi que ce soit.

---

## 1. Le projet en trois phrases

Pokémon Gamma Emerald est un fan-game Unreal Engine 5.6 de **UndreamedPanic**,
en accès anticipé. On le traduit en français **sans modifier un seul fichier
du jeu** : on ajoute un `Game.locres` externe, et le supprimer restaure le jeu
à l'octet près.

L'utilisateur s'appelle **Duc**, pseudo **NairoDraw**. Il décide, il joue, il
te montre les écrans. Un second traducteur, **TristanDuc**, est crédité.

---

## 2. Chiffres actuels

```
catalogue    8 340 entrées, dont 7 819 réellement traduites
moisson      7 101 paires relevées, 953 clés encore non rattachées
référence    1 033 noms officiels vérifiés un par un
Game.locres  886 962 octets  —  verdict FICHIER SAIN
```

Couverture mesurée dans le jeu : environ **83 %** des textes à clé chargés
dans les zones parcourues.

---

## 3. Les contraintes posées par Duc — ne les enfreins pas

1. **Aucun fichier du jeu n'est modifié.** Jamais. Le livrable est un
   `.locres` ajouté, plus un raccourci qui passe `-culture=fr`.
2. **Pas d'extraction de la clé AES.** Le développeur a chiffré son `.pak` et
   refusé de partager la clé. Localiser cette clé dans le binaire compte
   comme une extraction — c'est non.
3. **Pas de contournement du menu debug** verrouillé par le développeur.
4. **UE4SS est refusé.** Duc l'a explicitement écarté : ça transformerait le
   livrable en DLL injectée. Ne le repropose pas de toi-même.
5. **Jamais un nom officiel Pokémon écrit de mémoire.** Voir section 6.

---

## 4. Le format `.locres` — l'essentiel

Format **Legacy**, sans nombre magique :

```
uint32  nombre d'espaces de noms
  FString  nom de l'espace
  uint32   nombre de clés
    FString  clé (32 hexadécimaux)
    uint32   CRC de la source
    FString  traduction
```

`FString` = `int32` de longueur, puis les octets. Positif = ASCII + `\0`.
Négatif = `-(longueur+1)`, puis UTF-16LE + `\0\0`.

**Le CRC de la source est un piège central.** Le moteur compare le hachage
stocké au vrai texte source. Un seul espace de fin qui diffère, et la
traduction est jugée périmée : **l'anglais s'affiche**. `reparer_sources.py`
existe pour ça — il a débloqué 16 traductions d'un coup.

Dans le journal du jeu, `LocRes ... failed the magic number check!` est
**bon signe** : le fichier est trouvé et lu en format Legacy.

---

## 5. Le mur technique — fermé, ne le rouvre pas

**Les noms d'attaques et les noms d'espèces AFFICHÉS sont hors d'atteinte.**

Prouvé deux fois, par deux méthodes indépendantes :

- **août, mode `-LEET`** d'Unreal (qui transforme tout texte localisé en
  leetspeak) : `Mega Drain` reste intact alors que le libellé voisin
  `Current Moves` se transforme. Donc non localisé.
- **24 août, sonde mémoire pendant un combat réel** — `-LEET` n'existe plus
  en v3, build Shipping : `POOCHYENA` a **5 clés traduites et chargées**, et
  l'écran affiche quand même `Poochyena`.

### Le piège où je suis tombé — ne retombe pas dedans

Le catalogue contient **179 entrées dont la source est un nom d'espèce en
MAJUSCULES** (`POOCHYENA` → `MEDHYÈNA`, `TREECKO` → `ARCKO`, 69 espèces).
J'ai cru la piste rouverte et je l'ai annoncé à Duc. **C'était faux.**

Le jeu affiche la **casse mixte** (`Poochyena`, `Treecko`) sur les barres de
vie et dans le Pokédex, et cette forme-là ne porte **aucune clé**. Les entrées
majuscules servent ailleurs, ou sont orphelines d'une version antérieure.

> Si tu comptes 179 entrées et que tu te réjouis : relis ce paragraphe.

**En revanche les descriptions du Pokédex passent** — ce sont de vrais FText.
On y écrit le nom français (« Arcko possède sous les pattes… »), ce qui donne
l'illusion que le nom est traduit alors que le champ nom reste anglais.

### Trois lignes du journal de combat, non résolues

`A wild {name} appeared!`, `What will {name} do?`,
`{Player} sends out {PlayerMon}!` — localisées, mais leur clé vit dans une
structure `FTextData` séparée qu'on n'a pas su atteindre. Le catalogue
contient des variantes proches (`A wild {pokemon} has appeared!`) que le jeu
n'utilise pas. J'ai recommandé d'arrêter là.

---

## 6. La règle des noms officiels — la plus importante

**Chaque nom propre officiel se vérifie sur sa page Poképédia dédiée, une page
par nom, jamais sur un tableau de correspondance.**

Cette discipline a attrapé **huit erreurs réelles**, dont plusieurs que
j'aurais écrites avec une confiance totale :

| J'aurais écrit | Vrai nom officiel |
|---|---|
| M. BRINEY | **M. MARCO** |
| CAPITAINE STERN | **CAPITAINE POUPE** |
| M. STONE | **M. ROCHARD** |
| WANDA | **SYLVIE** |
| PIERRE ROCHARD pour Wally | **TIMMY** — Pierre Rochard, c'est Steven |
| Pokémon Chauve-Souris | **Pokémon Chovsouris** |
| Pokémon Hirondelle | **Pokémon Minirondel** |
| Tourbillon pour Whirlpool | **SIPHON** |

Et surtout **`MR BRICOULE`**, un nom purement inventé qui traînait sur
**65 entrées** et s'affichait dans le jeu de Duc. Personne ne l'avait vu :
un faux nom se lit parfaitement bien en français et ne casse aucun contrôle
automatique. **Seule la vérification les attrape.**

**Quand un nom n'existe pas** — `WALDA`, ou les noms inventés du fan-game :
`NIO`, `PEPPER`, `RYDEL`, `LUCIOUS`, `S.S. TIDAL`, `GAMMA EMERALD` —
**laisse-le en anglais**. Inventer est pire que ne pas traduire.

Les noms confirmés vont dans `REFERENCE_OFFICIELLE.json` (1 033 entrées :
`pokemon`, `capacites`, `lieux`, `objets`, `personnages`, `classes`,
`especes`, `categories`, `talents`). **Consulte-la avant de chercher en
ligne** — elle a déjà rattrapé `Whirlpool` = Siphon.

### Un cas qui illustre la règle

Les routes maritimes de Hoenn ne s'appellent pas « Route » mais **« Chenal »**,
et il n'y a aucune règle simple. Vérifié page par page :

```
Chenal : 105 106 107 108 122 124 125 126 127 128 129 130 131 132 133 134
Route  : 111 112 114 119 120 121
```

`Route 125` est une **redirection** vers `Chenal 125`. Un test naïf sur le
code HTTP l'aurait classé « Route ». Vérifie le contenu, pas juste l'existence.

### Le genre compte

L'anglais dit `TUBER` pour tout le monde. En français la classe s'accorde :
**GARÇON À LA BOUÉE** pour Chandler et Ricky, **FILLE À LA BOUÉE** pour Lola.
Pense à regarder qui parle.

---

## 7. Les outils — lesquels, dans quel ordre

Tous dans `_SAUVEGARDE_TRADUCTION_FR/_traduction_fr/`.

### Le cycle normal

```
1.  le jeu tourne, Duc joue
2.  py auditer.py                      relève la mémoire -> moisson.json
3.  py appliquer_moisson.py --ecrire   rattache le gratuit, aucune décision
4.  écrire un lot_v3_N.py              les vraies traductions
5.  py appliquer_par_fragment.py lot_v3_N.py            essai à blanc
6.  py appliquer_par_fragment.py lot_v3_N.py --integrer
7.  contrôler doublons et entrées vides
8.  py construire_locres.py
9.  py verif_locres.py Game.locres _locres_source.json  -> doit dire SAIN
10. copier Game.locres dans v3 ET dans les deux branches de source_du_paquet
11. py construire_paquets_separes.py
```

### Les deux appliqueurs — savoir lequel prendre

| Outil | Pour quoi |
|---|---|
| `appliquer_par_fragment.py` | **les phrases.** La clé du lot est un fragment distinctif de la source. Évite de retaper les apostrophes typographiques du jeu, qui se déforment au passage par la console. |
| `appliquer_exact.py` | **les libellés courts.** « Potion » est contenu dans « Super Potion », « DEWFORD » dans « DEWFORD TOWN » — le mode fragment refuse, à juste titre. Celui-ci compare la source entière. |

Les deux appliquent les mêmes contrôles bloquants : balises `<B>` `<G>`
identiques et dans le même ordre, substituts `{PlayerName}` tous conservés,
espaces de bord identiques, même nombre de retours à la ligne.

**Un fragment qui désigne zéro ou plusieurs sources est refusé.** C'est voulu.
Ne contourne pas : allonge le fragment, ou passe en exact. Si une source
courte est intégralement contenue dans une plus longue, aucun fragment ne peut
la désigner seule — traduis la longue et laisse la courte.

### Les autres

- **`auditer.py`** — relève la mémoire du jeu. **Ne l'appelle JAMAIS avec
  `--resume`** quand tu moissonnes : ce mode retourne AVANT d'écrire
  `moisson.json`. Ce piège a coûté une session entière, deux fois.
- **`prouver.py "fragment"`** — prouve les trois maillons : DÉTECTÉ (le jeu a
  la clé), COUVERT (on a la traduction), **CHARGÉ (le français est en
  mémoire)**. Seule la troisième colonne prouve quelque chose.
- **`signaler.py`** — touches globales pendant que Duc joue. **F8**
  photographie, **F9** moissonne la zone, **F10** arrête. La bonne méthode :
  traverser une zone en tapant F8 devant chaque texte anglais, puis **un seul
  F9** à la fin — la mémoire garde toute la zone.
- **`reparer_sources.py`** — répare les entrées dont la source diverge de la
  vraie (espaces de bord).
- **`construire_paquets_separes.py`** — une archive par plateforme.

---

## 8. Les pièges qui m'ont eu — lis avant de coder

### L'antislash en bash est un cauchemar

Le ZIP construit sous PowerShell 5.1 avec `ZipFile::CreateFromDirectory` écrit
les chemins avec des **antislashs**. Windows tolère, Linux non : `unzip` crée
un fichier nommé littéralement `LINUX\installer-fr.sh`, antislash compris.
**L'archive paraît parfaite sur la machine qui la fabrique et arrive cassée
chez celui qui la reçoit.** Un testeur Linux l'a signalé, pas moi.

Corrigé par `construire_paquet.py` (module `zipfile` de Python, toujours des
slashs), qui **refuse de produire l'archive** si un antislash s'y glisse.

Pire : en corrigeant le script d'installation, j'ai écrit `t="${f//\\//}"` —
qui **ne fait rien du tout**. Aucune forme de substitution bash ne marche sur
l'antislash, je les ai toutes essayées. **Une seule fonctionne :**

```bash
conv="$(printf '%s' "$base" | tr '\134' '/')"
```

`\134` est le code octal de l'antislash. **Teste ce genre de chose plutôt que
de raisonner** — j'ai failli livrer une deuxième version cassée.

### Autres pièges

- **`PrintWindow` avec `PW_RENDERFULLCONTENT`** dessine TOUTE la fenêtre,
  barre de titre comprise, dans un bitmap de la taille du client. L'origine de
  l'image est celle de la FENÊTRE : utilise `GetWindowRect`, jamais
  `ClientToScreen`. Décalage de 31 px sinon, invisible sur un composite.
- **Ne supprime jamais le livrable avant d'avoir vérifié le nouveau.** Une
  fois, un script a effacé l'archive puis échoué : livrable détruit, récupéré
  à la corbeille. Depuis, on construit à côté et on ne remplace qu'après
  contrôle automatique.
- **`auditer.py` mourait sur de l'UTF-16 invalide** en plein balayage, rendant
  une moisson tronquée **en silence**. Les `try/except` autour des deux
  décodages sont là pour ça — ne les retire pas.
- **Une clé en double fait échouer `construire_locres.py`**, qui abandonne. Si
  tu ne regardes pas, tu installes l'ANCIEN fichier et `verif_locres.py` te
  dit « FICHIER SAIN » à propos d'une version périmée. Contrôle les doublons
  avant de construire.
- **Le `.locres` n'est lu qu'au démarrage.** Compare l'heure du fichier au
  `StartTime` du processus avant de conclure que « ça ne marche pas ». Ça
  m'est arrivé.
- **v2 vs v3 :** l'exécutable change de nom (`PokemonEmerald.exe` →
  `PokemonEmerald-Win64-Shipping.exe`). Les scripts détectent large :
  `"pokemonemerald" in path and "binaries" in path and path.endswith(".exe")`.
  En v3 (Shipping), le jeu **efface l'`Engine.ini`** qu'il n'a pas créé — d'où
  le raccourci qui passe `-culture=fr` en argument, seule méthode fiable.

---

## 9. Où en est la traduction

**Zones bouclées :** Bourg-en-Vol et le labo · Routes 101/103/104 · Bois
Clémenti · Clémenti-Ville et son arène · Mérouville, la Devon SARL, l'école de
dresseurs, l'arène de Roxanne · le fleuriste Jolie Fleur · le tunnel Mérazon ·
M. Marco et la traversée · Myokara et l'arène de Bastien · Grotte Granite et
Pierre Rochard · Chenal 109 et la Maison du Bord de Mer · Poivressel : le
musée océanographique en entier, le marché, le port, la Team Aqua, le Club des
Fans · la Piste Cyclable et la Route 110.

**Interface :** menus, Pokédex, Sac, équipe, résumé, options, sauvegarde,
Centre Pokémon, boutiques, carte de dresseur.

**Aussi :** objets, CT et CS, Baies, Poké Balls, talents, natures, types,
badges, classes de dresseurs, descriptions du Pokédex des espèces croisées.

**Les lots** sont dans `lot_v3_1.py` à `lot_v3_7.py`, chacun documenté en
en-tête avec les noms officiels vérifiés pour ce lot. Lis-les : ils montrent
le style attendu et les décisions prises.

**Crédit à l'écran-titre.** Greffé sur deux entrées, clés
`F4CB8F6B4D5B787E97C8D49884A82500` et `15AE580F4D6689BA862650A93D7EBA89`.
La boîte fait **~1,5 ligne de haut et ~57 caractères de large** : une seconde
ligne se fait rogner par le bas, 58 caractères se font couper à droite. Forme
qui tient, vérifiée à l'écran :
`Créé par UndreamedPanic - FR : NairoDraw, TristanDuc` (52 caractères).

---

## 10. Ce qui reste à faire — par ordre de rendement

### 1. Le filon des noms et descriptions d'objets

**Le plus rentable.** Contrairement aux espèces, **les noms d'objets portent
des clés** et sont traduisibles. Plusieurs le sont déjà (`Great Ball` → Super
Ball, `Revive` → Rappel, `Rare Candy` → Super Bonbon, `Full Restore` →
Guérison), d'autres attendent avec leur clé libre (`Hard Stone`,
`Cherish Ball`).

Il y a plusieurs centaines d'objets dans le jeu. Ils se chargent quand Duc
**ouvre le Sac onglet par onglet, puis une boutique**. Demande-lui ça, puis F9.

### 2. Les descriptions du Pokédex

Elles marchent, et c'est là qu'on écrit les noms français. Duc a **118 espèces
vues** pour une poignée de descriptions traduites. Chaque fiche consultée
charge sa description en mémoire.

### 3. Continuer les zones

Après Poivressel : Lavandia, la Maison des Pièges, le Mont Chimnée.

### 4. Les 953 clés non rattachées

Beaucoup sont des identifiants techniques ou des réglages d'image, mais il
reste de vraies phrases. `auditer.py` les classe par nature dans `AUDIT.md`.

---

## 11. Comment travailler avec Duc

- **Il teste tout à l'écran.** Ne conclus jamais « ça marche » sans qu'il l'ait
  vu, ou sans une capture que tu as prise toi-même.
- **Il n'accepte pas « c'est impossible » sans preuve**, et il a eu raison au
  moins une fois : j'avais fermé une piste trop tôt. Distingue toujours « je
  n'ai pas trouvé » de « j'ai démontré que ça n'existe pas ».
- **Ses demandes de vérification paient.** C'est l'une d'elles qui a fait
  sortir `MR BRICOULE`.
- **Sois franc quand tu t'es trompé** : une phrase, la correction, et on
  avance. Ni excuses ni développement.
- **Les livrables vont dans le dossier `pokemon emerald`**, jamais sur le
  Bureau.
- Il parle français. Réponds en français.

---

## 12. Où sont les choses

```
Bureau/pokemon emerald/
├── v3/                                 le jeu — le dossier change à chaque version !
├── JOUER EN FRANCAIS + SIGNALEMENT.bat lance le jeu + signaler.py
├── A ENVOYER/                          livrables, vidéo de démo, post Discord
│   ├── PatchFR-GammaEmerald-Windows.zip / .rar
│   ├── PatchFR-GammaEmerald-Linux.tar.gz / .rar
│   ├── demo-fr-github.mp4              9,4 Mo, sous la limite GitHub de 10 Mo
│   ├── POST DISCORD.txt
│   ├── LISEZ-MOI - COMMENCER ICI.txt
│   └── MESSAGE POUR LE DEV.txt
└── _SAUVEGARDE_TRADUCTION_FR/
    ├── _traduction_fr/                 l'atelier : catalogue, outils, lots
    │   ├── traduction_fr.json          LE catalogue
    │   ├── moisson.json                ce que le jeu a montré
    │   ├── REFERENCE_OFFICIELLE.json   les 1 033 noms vérifiés
    │   ├── AUDIT.md                    dernier relevé, classé par nature
    │   └── _sauvegardes/               17 instantanés avant chaque gros lot
    ├── source_du_paquet/               WINDOWS/ et LINUX/, source des archives
    ├── superposition/                  capture d'écran (superposer.py)
    ├── _historique/                    anciennes versions de ce document
    └── POUR-UN-AUTRE-CLAUDE.md         ce fichier
```

**Le dépôt GitHub** est `NairoDraw/Patch-fr-pokemon-gamma`. Il portait encore
l'ancienne archive combinée `PokemonGammaEmerald_PatchFR.rar` au moment où
j'écris — à supprimer à la main quand les deux nouvelles seront en ligne.
