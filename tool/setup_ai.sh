#!/usr/bin/env bash
# Prepara el espacio de trabajo para cualquier agente: enlaza la fuente única
# (.agents/) en las carpetas que lee cada herramienta, instala las skills
# oficiales y resuelve dependencias de cada app.
#
# Funciona en macOS, Linux y Windows (Git Bash o WSL). En PowerShell usa
# tool/setup_ai.ps1.
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

step() { printf '\033[1m%s\033[0m\n' "$*"; }

is_windows() {
  case "$(uname -s)" in MINGW* | MSYS* | CYGWIN*) return 0 ;; *) return 1 ;; esac
}

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

step "1/4 Requisitos"
command -v flutter >/dev/null || { echo "Falta Flutter: https://docs.flutter.dev/get-started"; exit 1; }
dart_version="$(dart --version 2>&1 | sed -E 's/.*version: ([0-9]+\.[0-9]+).*/\1/')"
echo "  Dart $dart_version"
awk -v v="$dart_version" 'BEGIN { split(v, a, "."); exit !(a[1] > 3 || (a[1] == 3 && a[2] >= 9)) }' \
  || { echo "El Dart MCP server necesita Dart >= 3.9"; exit 1; }

step "2/4 Enlaces a la fuente única (.agents/)"
# Cada herramienta busca sus reglas, skills y agentes en su propia carpeta.
# Esas carpetas apuntan a .agents/ para que haya una sola fuente de verdad.
#   macOS / Linux / WSL: enlace simbólico.
#   Windows (Git Bash): unión de directorios (no pide permisos de administrador).
# Si el repo se clonó en Windows sin soporte de enlaces, git deja en su lugar
# un archivo de texto con la ruta: se reemplaza por el enlace real.
link() { # link <destino> <origen relativo a la carpeta del destino>
  local dest="$1" target="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" && ! -L "$dest" ]]; then
    rm -f "$dest"
  fi
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    if is_windows && [[ -d "$dest" ]] && cmd //c "fsutil reparsepoint query \"$(cygpath -w "$dest")\"" >/dev/null 2>&1; then
      echo "  $dest -> $target (unión existente)"
    else
      echo "  $dest ya existe y es una carpeta real: lo dejo como está"
    fi
    return
  fi
  if is_windows; then
    local abs_target
    abs_target="$(cd "$(dirname "$dest")" && cd "$target" && pwd)"
    rm -f "$dest"
    cmd //c "mklink /J \"$(cygpath -w "$dest")\" \"$(cygpath -w "$abs_target")\"" >/dev/null
    echo "  $dest -> $target (unión de Windows)"
  else
    ln -sfn "$target" "$dest"
    echo "  $dest -> $target"
  fi
}
link .claude/skills   ../.agents/skills
link .claude/agents   ../.agents/agents
link .gemini/agents   ../.agents/agents
link .gemini/skills   ../.agents/skills
link .agent/rules     ../.agents/rules
link .agent/workflows ../.agents/workflows
link .cursor/skills   ../.agents/skills
link .github/skills   ../.agents/skills

step "3/4 Skills oficiales (Flutter, Dart y Marionette)"
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

step "4/4 Dependencias de las apps"
for pubspec in apps/*/pubspec.yaml; do
  app="$(dirname "$pubspec")"
  echo "  $app"
  (cd "$app" && flutter pub get >/dev/null)
done
tool/index_apps.sh >/dev/null

if command -v uv >/dev/null; then
  echo "  flutter-radar: actualizando el índice de novedades"
  uv run -q tool/flutter_radar/radar.py ingest | tail -1 || echo "  flutter-radar: sin red, se omite"
else
  echo "  flutter-radar: instala uv (https://docs.astral.sh/uv/) para usar el radar"
fi

cat <<MSG

Listo. Abre tu agente en: $root
  claude   |  gemini   |  agy   |  codex
Pregúntale: "¿Qué reglas, skills, agentes y herramientas MCP cargaste de esta carpeta?"
Stitch necesita STITCH_API_KEY y Developer Knowledge GOOGLE_DK_API_KEY; Figma pide login la primera vez.
Para que el agente maneje la app: flutter run y pásale el URI del VM service.
MSG
