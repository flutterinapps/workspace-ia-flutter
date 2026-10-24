# Prepara el espacio de trabajo en Windows desde PowerShell (sin Git Bash).
# Hace lo mismo que tool/setup_ai.sh. Uso, desde la raíz del repo:
#   powershell -ExecutionPolicy Bypass -File tool\setup_ai.ps1
#   powershell -ExecutionPolicy Bypass -File tool\setup_ai.ps1 -Update
param([switch]$Update)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
$root = (Get-Location).Path

function Step($text) { Write-Host $text -ForegroundColor Magenta }
$officialRepo = 'https://github.com/flutter/agent-plugins'
$marionetteRepo = 'https://github.com/leancodepl/marionette_mcp'

Step '1/4 Requisitos'
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw 'Falta Flutter: https://docs.flutter.dev/get-started'
}
$dartVersion = [regex]::Match((dart --version 2>&1 | Out-String), 'version: (\d+)\.(\d+)')
if (-not $dartVersion.Success -or [int]$dartVersion.Groups[1].Value -lt 3 -or
    ([int]$dartVersion.Groups[1].Value -eq 3 -and [int]$dartVersion.Groups[2].Value -lt 9)) {
  throw 'El Dart MCP server necesita Dart >= 3.9'
}
Write-Host "  Dart $($dartVersion.Groups[1].Value).$($dartVersion.Groups[2].Value)"

Step '2/4 Enlaces a la fuente única (.agents\)'
# Uniones de directorio: funcionan sin permisos de administrador ni Modo desarrollador.
# Si git dejó un archivo de texto en lugar del enlace, se reemplaza.
$links = @(
  @('.claude\skills', '.agents\skills'), @('.claude\agents', '.agents\agents'),
  @('.gemini\agents', '.agents\agents'), @('.gemini\skills', '.agents\skills'),
  @('.agent\rules', '.agents\rules'), @('.agent\workflows', '.agents\workflows'),
  @('.cursor\skills', '.agents\skills'), @('.github\skills', '.agents\skills')
)
foreach ($pair in $links) {
  $dest = Join-Path $root $pair[0]
  $target = Join-Path $root $pair[1]
  New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
  $item = Get-Item $dest -Force -ErrorAction SilentlyContinue
  if ($item -and -not $item.PSIsContainer) { Remove-Item $dest -Force; $item = $null }
  if ($item -and $item.LinkType) { Write-Host "  $($pair[0]) -> $($pair[1]) (ya enlazado)"; continue }
  if ($item) { Write-Host "  $($pair[0]) ya existe y es una carpeta real: lo dejo como está"; continue }
  New-Item -ItemType Junction -Path $dest -Target $target | Out-Null
  Write-Host "  $($pair[0]) -> $($pair[1])"
}

Step '3/4 Skills oficiales (Flutter, Dart y Marionette)'
if ($Update) {
  dart run skills@ get --agent generic --all | Out-Null
  Write-Host '  Revisa los cambios con: git status .agents/skills'
} elseif (-not (Test-Path '.agents\skills\flutter-add-widget-preview')) {
  dart run skills@ add $officialRepo --agent generic --all | Out-Null
  dart run skills@ add $marionetteRepo --agent generic --all | Out-Null
} else {
  $count = (Get-ChildItem '.agents\skills' -Directory).Count
  Write-Host "  ya instaladas ($count skills; usa -Update para actualizar las oficiales)"
}
Write-Host '  marionette_mcp (el agente maneja la app corriendo)'
dart pub global activate marionette_mcp | Out-Null

Step '4/4 Dependencias de las apps'
Get-ChildItem 'apps' -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'pubspec.yaml') } | ForEach-Object {
  Write-Host "  apps\$($_.Name)"
  Push-Location $_.FullName; flutter pub get | Out-Null; Pop-Location
}
if (Get-Command bash -ErrorAction SilentlyContinue) { bash tool/index_apps.sh | Out-Null }
if (Get-Command uv -ErrorAction SilentlyContinue) {
  Write-Host '  flutter-radar: actualizando el índice de novedades'
  uv run -q tool/flutter_radar/radar.py ingest | Select-Object -Last 1
} else {
  Write-Host '  flutter-radar: instala uv (https://docs.astral.sh/uv/) para usar el radar'
}

Write-Host ''
Write-Host "Listo. Abre tu agente en: $root"
Write-Host '  claude   |  gemini   |  agy   |  codex'
Write-Host 'Pregúntale: "¿Qué reglas, skills, agentes y herramientas MCP cargaste de esta carpeta?"'
