#!/usr/bin/env bash
# Guardarraíl: tras cada edición de un .dart, formatea y analiza ese archivo.
# Si el analizador encuentra errores o warnings, sale con 2 para que el agente
# los lea y los corrija (Claude Code muestra stderr al modelo).
set -uo pipefail

input="$(cat)"
# Extrae tool_input.file_path sin depender de python (no siempre está en Windows).
file="$(printf '%s' "$input" | tr -d '\n' | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | sed 's/\\\\/\\/g')"
if command -v cygpath >/dev/null && [[ "$file" == [A-Za-z]:* ]]; then file="$(cygpath -u "$file")"; fi

[[ "$file" == *.dart && -f "$file" ]] || exit 0
[[ "$file" == */generated/* || "$file" == *.g.dart ]] && exit 0

dart format --output=write "$file" >/dev/null 2>&1

app_dir="$(dirname "$file")"
while [[ "$app_dir" != "/" && ! -f "$app_dir/pubspec.yaml" ]]; do
  app_dir="$(dirname "$app_dir")"
done
[[ -f "$app_dir/pubspec.yaml" ]] || exit 0

report="$(cd "$app_dir" && dart analyze "$file" 2>&1)"
if printf '%s' "$report" | grep -qE '^[[:space:]]*(error|warning) -'; then
  echo "dart analyze encontró problemas en $file:" >&2
  printf '%s\n' "$report" | grep -E '^[[:space:]]*(error|warning) -' >&2
  exit 2
fi
exit 0
