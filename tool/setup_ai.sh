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
marionette_repo="https://github.com/leancodepl/marionette_mcp"

# Skills oficiales que no queremos (CLI, FFI...). Ver .agents/skills-exclude.txt.
remove_excluded_skills() {
  local args=()
  while IFS= read -r skill; do
    [[ -z "$skill" || "$skill" == \#* ]] && continue
    [[ -d ".agents/skills/$skill" ]] && args+=(-s "$skill")
  done < .agents/skills-exclude.txt
  if (( ${#args[@]} > 0 )); then
    dart run skills@ remove --agent generic --git "$official_repo" "${args[@]}" >/dev/null
  fi
}

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
if $update; then
  dart run skills@ get --agent generic --all >/dev/null
  remove_excluded_skills
  if [[ -z "$(git status --porcelain -- .agents/skills)" ]]; then
    echo "  Sin cambios: las skills oficiales ya están al día."
  else
    echo "  Cambios en las skills oficiales (revísalos antes del commit):"
    git status --short -- .agents/skills
  fi
elif [[ ! -d .agents/skills/flutter-add-widget-preview ]]; then
  dart run skills@ add "$official_repo" --agent generic --all >/dev/null
  dart run skills@ add "$marionette_repo" --agent generic --all >/dev/null
  remove_excluded_skills
else
  echo "  ya instaladas ($(ls .agents/skills | wc -l | tr -d ' ') skills; usa --update para actualizar las oficiales)"
fi

echo "  marionette_mcp (el agente maneja la app corriendo)"
dart pub global activate marionette_mcp >/dev/null

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
Stitch necesita la variable STITCH_API_KEY; Figma pide login la primera vez.\nPara que el agente maneje la app: flutter run y pásale el URI del VM service.
MSG
