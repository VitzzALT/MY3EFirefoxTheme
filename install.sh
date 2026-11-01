#!/usr/bin/env bash
# MY3E Firefox Theme - instalador para Linux
# Uso:    bash install.sh
# Opções: --uninstall   remove o tema
#         --no-homepage não define a página inicial
set -euo pipefail

RAW="https://raw.githubusercontent.com/VitzzALT/MY3EFirefoxTheme/main"
PAGE="https://vitzzalt.github.io/MY3EFirefoxTheme/"
MARK="// MY3E"
UNINSTALL=0; HOMEPAGE=1
for a in "$@"; do
  case "$a" in
    --uninstall) UNINSTALL=1 ;;
    --no-homepage) HOMEPAGE=0 ;;
  esac
done

if pgrep -x firefox >/dev/null 2>&1; then
  echo "Feche o Firefox por completo e rode o script de novo." >&2
  exit 1
fi

# 1) Descobre a pasta do Firefox (normal, XDG, Flatpak ou Snap)
BASE=""
for d in "$HOME/.mozilla/firefox" "$HOME/.config/mozilla/firefox" \
         "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox" \
         "$HOME/snap/firefox/common/.mozilla/firefox"; do
  if [ -f "$d/profiles.ini" ]; then BASE="$d"; break; fi
done
[ -n "$BASE" ] || { echo "Não encontrei o profiles.ini. Abra o Firefox uma vez e tente de novo." >&2; exit 1; }

# 2) Descobre o perfil padrão
REL=$(awk -F= '/^\[Install/{i=1;next} /^\[/{i=0} i && $1=="Default"{print $2; exit}' "$BASE/profiles.ini")
if [ -z "$REL" ]; then
  REL=$(awk -F= '/^\[/{ if(d&&p){print p; exit} p="";d=0; next } $1=="Path"{p=$2} $1=="Default"&&$2=="1"{d=1} END{ if(d&&p) print p }' "$BASE/profiles.ini")
fi
[ -n "$REL" ] || { echo "Não consegui descobrir o perfil padrão." >&2; exit 1; }
case "$REL" in /*) PROF="$REL" ;; *) PROF="$BASE/$REL" ;; esac
echo "Perfil: $PROF"

CSS="$PROF/chrome/userChrome.css"
USERJS="$PROF/user.js"

clear_mine() {
  if [ -f "$USERJS" ]; then
    grep -vF "$MARK" "$USERJS" > "$USERJS.tmp" || true
    mv "$USERJS.tmp" "$USERJS"
  fi
}

if [ "$UNINSTALL" = 1 ]; then
  rm -f "$CSS"
  clear_mine
  echo "Tema removido. Abra o Firefox para voltar ao visual normal."
  exit 0
fi

# 3) Instala o userChrome.css (com backup do que já existir)
mkdir -p "$PROF/chrome"
if [ -f "$CSS" ]; then
  BAK="$CSS.bak-$(date +%Y%m%d-%H%M%S)"
  cp "$CSS" "$BAK"
  echo "Backup do CSS anterior: $BAK"
fi
curl -fsSL "$RAW/userChrome.css" -o "$CSS"

# 4) Ativa o suporte ao userChrome.css (e define a página inicial)
clear_mine
{
  echo "user_pref(\"toolkit.legacyUserProfileCustomizations.stylesheets\", true); $MARK"
  if [ "$HOMEPAGE" = 1 ]; then
    echo "user_pref(\"browser.startup.homepage\", \"$PAGE\"); $MARK"
    echo "user_pref(\"browser.startup.page\", 1); $MARK"
  fi
} >> "$USERJS"

echo
echo "Pronto! Abra o Firefox."
echo "Falta só a nova aba: instale a extensão \"New Tab Override\" e use a URL personalizada:"
echo "  $PAGE"
