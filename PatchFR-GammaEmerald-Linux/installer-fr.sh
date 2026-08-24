#!/usr/bin/env bash
#
# Installe la traduction francaise de Pokemon Gamma Emerald.
# Linux : Bazzite, SteamOS, Fedora, Arch... avec Faugus Launcher, Lutris,
# Heroic, Bottles ou Steam/Proton.
#
#   bash installer-fr.sh                 -> cherche le jeu tout seul
#   bash installer-fr.sh /chemin/du/jeu  -> si tu connais le chemin
#
set -u
R=$'\e[31m'; V=$'\e[32m'; J=$'\e[33m'; G=$'\e[1m'; N=$'\e[0m'
ici="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "${G}Traduction francaise -- Pokemon Gamma Emerald${N}"
echo

# --- 0. reparer une archive extraite avec des chemins Windows ---------------
# Un ZIP fabrique sous Windows peut contenir des ANTISLASHS comme separateurs.
# unzip cree alors un fichier nomme "LINUX\PokemonEmerald\...", antislash
# compris, au lieu d'une arborescence. On la reconstruit ici.
#
# tr '\134' est la SEULE forme qui marche : \134 est le code octal de
# l'antislash. Les substitutions bash ${x//...} echouent toutes sur ce
# caractere, quelle que soit la facon de l'echapper -- teste.
repare=0
while IFS= read -r -d '' f; do
    base="$(basename "$f")"
    conv="$(printf '%s' "$base" | tr '\134' '/')"
    [ "$conv" = "$base" ] && continue
    cible="$ici/$conv"
    mkdir -p "$(dirname "$cible")"
    mv -f "$f" "$cible"
    repare=$((repare+1))
done < <(find "$ici" -maxdepth 1 -type f -print0 2>/dev/null)
[ "$repare" -gt 0 ] && echo "${J}[i]${N} $repare fichier(s) remis dans la bonne arborescence." && echo

src="$ici/PokemonEmerald/Content/Localization/Game/fr/Game.locres"
if [ ! -f "$src" ]; then
    echo "${R}Game.locres introuvable dans le dossier du patch.${N}"
    find "$ici" -maxdepth 4 | sed "s|$ici|  .|"
    exit 1
fi
echo "${V}[ok]${N} traduction trouvee dans le patch"

# --- 1. trouver le jeu -------------------------------------------------------
jeu=""
if [ $# -ge 1 ]; then
    jeu="${1%/}"
    [ -f "$jeu/PokemonEmerald.exe" ] || { echo "${R}Pas de PokemonEmerald.exe dans :${N} $jeu"; exit 1; }
else
    for c in "$(dirname "$ici")" "$(dirname "$(dirname "$ici")")"; do
        [ -f "$c/PokemonEmerald.exe" ] && jeu="$c" && break
    done
    if [ -z "$jeu" ]; then
        echo "Recherche du jeu..."
        while IFS= read -r f; do
            d="$(dirname "$f")"
            [ -d "$d/PokemonEmerald/Content" ] || continue
            jeu="$d"; break
        done < <(find "$HOME" -maxdepth 8 -name "PokemonEmerald.exe" -not -path "*/Binaries/*" 2>/dev/null)
    fi
fi
[ -z "$jeu" ] && {
    echo "${R}Jeu introuvable.${N}"
    echo "Relance en donnant le chemin :"
    echo "   ${G}bash installer-fr.sh /chemin/vers/gamma-emerald${N}"
    echo "Astuce Faugus : clic droit sur le jeu > Edit, le champ du haut donne le chemin."
    exit 1; }
echo "${V}[ok]${N} jeu trouve : $jeu"
echo

# --- 2. installer ------------------------------------------------------------
dest="$jeu/PokemonEmerald/Content/Localization/Game/fr"
mkdir -p "$dest" || { echo "${R}Ecriture impossible${N}"; exit 1; }
cp -f "$src" "$dest/Game.locres" || { echo "${R}Copie echouee${N}"; exit 1; }
echo "  [ok] Game.locres installe ($(stat -c%s "$dest/Game.locres" 2>/dev/null || echo '?') octets)"

NL=$'
'
# Le jeu lit sa langue dans son dossier Saved, dont l'emplacement DEPEND DU
# TYPE DE COMPILATION :
#     build Development : <dossier du jeu>/PokemonEmerald/Saved/
#     build Shipping    : %LOCALAPPDATA%/PokemonEmerald/Saved/
# Les versions 1.13 et suivantes sont en Shipping, d'ou un Engine.ini pose
# dans le dossier du jeu qui reste sans effet. On ecrit donc dans TOUS les
# emplacements plausibles : au pire un fichier est ignore, rien ne casse.

cibles="$jeu/PokemonEmerald/Saved/Config/Windows"
for pfx in "$HOME/.steam/steam/steamapps/compatdata"/*/pfx \
           "$HOME/.local/share/Steam/steamapps/compatdata"/*/pfx \
           "$HOME/Games"/*/pfx "$HOME/.wine"; do
    [ -d "$pfx/drive_c/users" ] || continue
    for u in "$pfx/drive_c/users"/*; do
        [ -d "$u" ] || continue
        cibles="$cibles${NL}$u/AppData/Local/PokemonEmerald/Saved/Config/Windows"
    done
done

n_ok=0
while IFS= read -r cfg; do
    [ -n "$cfg" ] || continue
    mkdir -p "$cfg" 2>/dev/null || continue
    ini="$cfg/Engine.ini"
    if [ -f "$ini" ] && grep -qi '^Culture=fr' "$ini"; then
        echo "  [ok] deja configure : $ini"
        n_ok=$((n_ok + 1))
        continue
    fi
    [ -f "$ini" ] && cp -f "$ini" "$ini.avant-traduction-fr"
    if printf '\r\n[Internationalization]\r\nCulture=fr\r\nLanguage=fr\r\n' >> "$ini" 2>/dev/null; then
        echo "  [ok] Engine.ini configure : $ini"
        n_ok=$((n_ok + 1))
    fi
done <<CIBLES
$cibles
CIBLES

[ "$n_ok" -eq 0 ] && echo "  ${J}[!]${N} aucun Engine.ini ecrit -- utilise jouer-en-francais.sh"
echo "  [i] En cas de doute, jouer-en-francais.sh force la langue au lancement."

for lang in fr en; do
    nom="jouer-en-francais.sh"; [ "$lang" = en ] && nom="jouer-en-anglais.sh"
    cat > "$jeu/$nom" << LANCEUR
#!/usr/bin/env bash
cd "\$(dirname "\$0")" || exit 1
if command -v umu-run >/dev/null 2>&1; then exec umu-run ./PokemonEmerald.exe -culture=$lang
elif command -v proton >/dev/null 2>&1; then exec proton run ./PokemonEmerald.exe -culture=$lang
else exec wine ./PokemonEmerald.exe -culture=$lang; fi
LANCEUR
    chmod +x "$jeu/$nom"
done
echo "  [ok] jouer-en-francais.sh et jouer-en-anglais.sh"

echo
echo "${G}Verification :${N}"
[ -f "$dest/Game.locres" ] && echo "  ${V}v${N} traduction en place" || echo "  ${R}x${N} absente !"
grep -qi '^Culture=fr' "$ini" && echo "  ${V}v${N} Culture=fr dans Engine.ini" || echo "  ${J}!${N} non confirme"
echo
echo "${V}${G}Termine.${N}  Lance le jeu normalement depuis Faugus."
echo
echo "${G}Si le jeu reste en anglais${N} -- ajoute l'argument  ${G}-culture=fr${N}  :"
echo "   Faugus : clic droit sur le jeu > Edit > champ des arguments"
echo "   Lutris : Configurer > Options du jeu > Arguments"
echo "   Heroic : Parametres du jeu > Arguments avances"
echo "   Steam  : Proprietes > Options de lancement > %command% -culture=fr"
echo
echo "${G}Pour desinstaller :${N}   bash desinstaller-fr.sh"
echo
