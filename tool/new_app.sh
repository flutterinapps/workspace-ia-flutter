#!/usr/bin/env bash
# Crea una app Flutter en apps/<nombre> ya conectada al espacio de trabajo.
# Uso: tool/new_app.sh <nombre_snake_case> ["descripción"]
set -euo pipefail
cd "$(dirname "$0")/.."

name="${1:?Uso: tool/new_app.sh <nombre_snake_case> [\"descripción\"]}"
desc="${2:-Flutter app}"
[[ "$name" =~ ^[a-z][a-z0-9_]*$ ]] || { echo "El nombre debe ser snake_case"; exit 1; }
dir="apps/$name"
[[ -e "$dir" ]] && { echo "$dir ya existe"; exit 1; }

flutter create --project-name "$name" --description "$desc" \
  --platforms ios,android --empty "$dir" >/dev/null

cp templates/app/analysis_options.yaml templates/app/l10n.yaml "$dir/"
mkdir -p "$dir/lib/l10n" "$dir/design" \
  "$dir/lib"/{core/theme,domain/{models,repositories},data/{datasources,repositories_impl},presentation/{providers,screens,widgets}}
cp templates/app/app_en.arb templates/app/app_es.arb "$dir/lib/l10n/"
cp templates/app/components.md "$dir/design/"
sed -e "s/{{name}}/$name/g" -e "s/{{description}}/$desc/g" templates/app/AGENTS.md > "$dir/AGENTS.md"

(
  cd "$dir"
  flutter pub add provider intl flutter_localizations --sdk=flutter >/dev/null 2>&1 \
    || { flutter pub add provider intl >/dev/null; flutter pub add flutter_localizations --sdk=flutter >/dev/null; }
  flutter pub add dev:checks >/dev/null
  # Activa la generación de l10n.
  grep -q 'generate: true' pubspec.yaml \
    || perl -0pi -e 's/^flutter:\n/flutter:\n  generate: true\n/m' pubspec.yaml
  flutter pub get >/dev/null
  flutter analyze >/dev/null && echo "flutter analyze: sin issues"
)

tool/index_apps.sh
echo "App creada en $dir. Completa $dir/AGENTS.md con lo propio de la app."
