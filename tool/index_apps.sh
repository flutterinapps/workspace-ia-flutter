#!/usr/bin/env bash
# Regenera WORKSPACE_INDEX.md: el mapa barato que el agente lee para ubicarse.
set -euo pipefail
cd "$(dirname "$0")/.."

dep() { grep -qE "^  $1:" "$2" && echo yes || true; }

{
  echo "# Índice de apps"
  echo
  echo "Generado por \`tool/index_apps.sh\`. No editar a mano."
  echo
  echo "| App | Descripción | Estado | Plataformas | Tests | Diseño |"
  echo "|---|---|---|---|---|---|"
  for pubspec in apps/*/pubspec.yaml; do
    dir="$(dirname "$pubspec")"
    name="$(basename "$dir")"
    desc="$(grep -E '^description:' "$pubspec" | sed -E 's/^description: *"?([^"]*)"?/\1/')"
    state="nativo"
    if [[ -n "$(dep provider "$pubspec")" ]]; then state="provider"; fi
    if [[ -n "$(dep flutter_bloc "$pubspec")" ]]; then state="bloc"; fi
    platforms="$(for p in android ios web macos linux windows; do if [[ -d "$dir/$p" ]]; then printf '%s ' "$p"; fi; done)"
    tests="$( (find "$dir/test" -name '*_test.dart' 2>/dev/null || true) | wc -l | tr -d ' ')"
    design="—"
    if [[ -f "$dir/design/tokens.json" ]]; then design="tokens.json"; fi
    echo "| [\`$name\`]($dir/AGENTS.md) | $desc | $state | ${platforms% } | $tests | $design |"
  done
  echo
  echo "Comandos (dentro de \`apps/<app>\`): \`flutter pub get\` · \`flutter analyze\` · \`flutter test\` · \`flutter run\`"
} > WORKSPACE_INDEX.md
echo "WORKSPACE_INDEX.md actualizado"
