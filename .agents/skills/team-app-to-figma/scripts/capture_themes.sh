#!/usr/bin/env bash
# Captura la pantalla actual de la app en claro y oscuro con marionette y deja
# la apariencia del dispositivo como estaba.
# Uso: capture_themes.sh <ws://…/ws> <carpeta> <id_pantalla> [udid_ios | android]
set -euo pipefail
ws="$1"; dir="$2"; id="$3"; target="${4:-booted}"
mkdir -p "$dir"
marionette="${MARIONETTE:-marionette}"

appearance() { # appearance get | appearance set <light|dark>
  if [[ "$target" == android ]]; then
    if [[ "$1" == get ]]; then
      adb shell cmd uimode night | grep -q yes && echo dark || echo light
    else
      adb shell cmd uimode night "$([[ "$2" == dark ]] && echo yes || echo no)" >/dev/null
    fi
  else
    if [[ "$1" == get ]]; then xcrun simctl ui "$target" appearance
    else xcrun simctl ui "$target" appearance "$2"; fi
  fi
}

original="$(appearance get)"
for theme in light dark; do
  appearance set "$theme"
  sleep 2
  "$marionette" --uri "$ws" take-screenshots --no-open --output "$dir/${id}_${theme}.png" >/dev/null
  echo "$dir/${id}_${theme}.png"
done
appearance set "$original"
