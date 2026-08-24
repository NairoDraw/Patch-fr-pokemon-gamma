#!/usr/bin/env bash
# Retire la traduction francaise et remet le jeu en anglais.
set -u
R=$'\e[31m'; V=$'\e[32m'; G=$'\e[1m'; N=$'\e[0m'
jeu="${1:-}"
if [ -z "$jeu" ]; then
    ici="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    for c in "$(dirname "$ici")" "$(dirname "$(dirname "$ici")")"; do
        [ -f "$c/PokemonEmerald.exe" ] && jeu="$c" && break
    done
    if [ -z "$jeu" ]; then
        while IFS= read -r f; do
            d="$(dirname "$f")"
            [ -d "$d/PokemonEmerald/Content" ] || continue
            jeu="$d"; break
        done < <(find "$HOME" -maxdepth 8 -name "PokemonEmerald.exe" -not -path "*/Binaries/*" 2>/dev/null)
    fi
fi
[ -z "$jeu" ] && { echo "${R}Jeu introuvable. Donne le chemin en argument.${N}"; exit 1; }
echo; echo "${G}Desinstallation depuis :${N} $jeu"; echo
loc="$jeu/PokemonEmerald/Content/Localization"
[ -d "$loc" ] && rm -rf "$loc" && echo "  [ok] traduction retiree" || echo "  [--] aucune traduction installee"
ini="$jeu/PokemonEmerald/Saved/Config/Windows/Engine.ini"
if [ -f "$ini.avant-traduction-fr" ]; then
    mv -f "$ini.avant-traduction-fr" "$ini"; echo "  [ok] Engine.ini restaure"
elif [ -f "$ini" ]; then
    sed -i '/^\[Internationalization\]/d;/^Culture=/d;/^Language=/d' "$ini"
    echo "  [ok] section [Internationalization] retiree"
fi
rm -f "$jeu/jouer-en-francais.sh" "$jeu/jouer-en-anglais.sh"
echo; echo "${V}${G}Le jeu est revenu a son etat d'origine.${N}"; echo
