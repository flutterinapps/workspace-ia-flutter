#!/usr/bin/env bash
# Guardarraíl: tras cada edición de un .dart, formatea y analiza ese archivo.
# Si el analizador encuentra errores o warnings, sale con 2 para que el agente
# los lea y los corrija (Claude Code muestra stderr al modelo).
set -uo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("tool_input",{}).get("file_path",""))' 2>/dev/null)"

[[ "$file" == *.dart && -f "$file" ]] || exit 0
[[ "$file" == */generated/* || "$file" == *.g.dart ]] && exit 0

dart format --output=write "$file" >/dev/null 2>&1

app_dir="$(dirname "$file")"
while [[ "$app_dir" != "/" && ! -f "$app_dir/pubspec.yaml" ]]; do
  app_dir="$(dirname "$app_dir")"
done
[[ -f "$app_dir/pubspec.yaml" ]] || exit 0

report="$(cd "$app_dir" && dart analyze --fatal-infos=false "$file" 2>&1)"
if printf '%s' "$report" | grep -qE '^\s*(error|warning) '; then
  echo "dart analyze encontró problemas en $file:" >&2
  printf '%s\n' "$report" | grep -E '^\s*(error|warning) ' >&2
  exit 2
fi
exit 0
