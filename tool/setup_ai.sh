#!/usr/bin/env bash
# Prepara el espacio de trabajo para cualquier agente: enlaza la fuente única
# (.agents/) en las carpetas que lee cada herramienta, instala las skills
# oficiales y resuelve dependencias de cada app.
#
# Uso: tool/setup_ai.sh            prepara el workspace
#      tool/setup_ai.sh --update   además trae la última versión de las skills
#                                  oficiales y muestra qué cambió
set -euo pipefail
cd "$(dirname "$0")/.."
root="$PWD"

update=false
case "${1:-}" in
  --update) update=true ;;
  "") ;;
  *) echo "Uso: tool/setup_ai.sh [--update]"; exit 1 ;;
esac

official_repo="https://github.com/flutter/agent-plugins"

# Las skills oficiales que usamos están registradas en
# .config/dart_skills/skills_config.json. Instalar o actualizar solo esas
# evita que vuelvan las que quitamos a propósito.
official_skills() {
  python3 - "$official_repo" <<'PY'
import json, sys
config = json.load(open(".config/dart_skills/skills_config.json"))
skills = config["installations"]["generic"][sys.argv[1]]["skills"]
print("\n".join(skill["name"] for skill in skills))
PY
}

say() { printf '\033[1m%s\033[0m\n' "$*"; }

say "1/4 Requisitos"
command -v flutter >/dev/null || { echo "Falta Flutter: https://docs.flutter.dev/get-started"; exit 1; }
dart_version="$(dart --version 2>&1 | sed -E 's/.*version: ([0-9]+\.[0-9]+).*/\1/')"
echo "Dart $dart_version"
awk -v v="$dart_version" 'BEGIN { split(v, a, "."); exit !(a[1] > 3 || (a[1] == 3 && a[2] >= 9)) }' \
  || { echo "El Dart MCP server necesita Dart >= 3.9"; exit 1; }

say "2/4 Enlaces a la fuente única (.agents/)"
link() { # link <destino> <origen relativo al destino>
  mkdir -p "$(dirname "$1")"
  if [[ -L "$1" || ! -e "$1" ]]; then
    ln -sfn "$2" "$1" && echo "  $1 -> $2"
  else
    echo "  $1 ya existe y no es un enlace: lo dejo como está"
  fi
}
link .claude/skills  ../.agents/skills
link .claude/agents  ../.agents/agents
link .gemini/agents  ../.agents/agents
link .gemini/skills  ../.agents/skills
link .agent/rules    ../.agents/rules
link .agent/workflows ../.agents/workflows
link .cursor/skills  ../.agents/skills
link .github/skills  ../.agents/skills

say "3/4 Skills oficiales (flutter/agent-plugins: Flutter + Dart)"
skill_args=()
while IFS= read -r skill; do skill_args+=(-s "$skill"); done < <(official_skills)

if $update; then
  dart run skills@ get --git "$official_repo" --agent generic "${skill_args[@]}"
  if git diff --quiet -- .agents/skills; then
    echo "  Sin cambios: las skills oficiales ya están al día."
  else
    echo "  Cambios de Flutter en las skills (revísalos antes del commit):"
    git diff --stat -- .agents/skills
  fi
elif [[ ! -d .agents/skills/flutter-add-widget-preview ]]; then
  dart run skills@ add "$official_repo" --agent generic "${skill_args[@]}"
else
  echo "  ya instaladas ($(( ${#skill_args[@]} / 2 )) oficiales; usa --update para actualizarlas)"
fi

say "4/4 Dependencias de las apps"
for pubspec in apps/*/pubspec.yaml; do
  app="$(dirname "$pubspec")"
  echo "  $app"
  (cd "$app" && flutter pub get >/dev/null)
done
tool/index_apps.sh >/dev/null

cat <<MSG

Listo. Abre tu agente en: $root
  claude   |  gemini   |  agy   |  codex
Pregúntale: "¿Qué reglas, skills, agentes y herramientas MCP tienes cargados?"
Stitch necesita la variable STITCH_API_KEY; Figma pide login la primera vez.
MSG
