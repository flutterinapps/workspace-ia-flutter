# Workspace IA Flutter

Un **espacio de trabajo para agentes de IA** que desarrollan apps Flutter con
buenas prácticas. Funciona con Claude Code, Gemini CLI, Antigravity, Codex,
Cursor y GitHub Copilot.

> El arnés (Claude Code, Gemini CLI, Antigravity…) es el mismo para todos.
> El espacio de trabajo —reglas, skills, agentes, herramientas y controles— es tu ventaja.

## Empezar (2 minutos)

```bash
git clone <este-repo> && cd workspace-ia-flutter
tool/setup_ai.sh          # enlaces por agente, skills oficiales, pub get
claude                    # o: gemini · agy · codex · code . (Copilot) · cursor .
```

Primera pregunta al agente: *"¿Qué reglas, skills, agentes y herramientas MCP
tienes cargados?"*

Requisitos: Flutter 3.38+ (Dart ≥ 3.9 para el Dart MCP server). Opcional:
`STITCH_API_KEY` para Stitch. Figma en Claude Code viene con su plugin oficial:
`claude plugin install figma@claude-plugins-official` (pide login la primera vez).

## Las 8 piezas

| Pieza | Cuándo entra al contexto | Dónde |
|---|---|---|
| Reglas (AI rules) | Siempre | `AGENTS.md` + `.agents/rules/` |
| Skills | Solo nombre y descripción; el resto bajo demanda | `.agents/skills/` |
| Package skills | Igual, instaladas con `package:skills` | `.agents/skills/` + `.config/dart_skills/` |
| Agentes especializados | Al invocarlos, en contexto aislado | `.agents/agents/` |
| Dart & Flutter MCP | Sus herramientas, al iniciar | `.mcp.json` y equivalentes |
| MCP de diseño (Figma, Stitch) | Sus herramientas, al iniciar | idem |
| Guardarraíles | No es contexto: se ejecutan | `tool/hooks/`, `analysis_options.yaml` |
| Índice | Siempre (es pequeño) | `WORKSPACE_INDEX.md` |

Orden de lectura: global del usuario (`~/.claude`, `~/.gemini`) → raíz del repo
→ carpeta donde trabajas (`apps/<app>/AGENTS.md`) → skills y agentes solo al
usarse.

## Qué lee cada agente

| Agente | Reglas | Skills | Agentes | MCP |
|---|---|---|---|---|
| Claude Code | `CLAUDE.md` → `@AGENTS.md` | `.claude/skills` → `.agents/skills` | `.claude/agents` | `.mcp.json` |
| Gemini CLI | `GEMINI.md` → `@AGENTS.md` | `.gemini/skills` | `.gemini/agents` | `.gemini/settings.json` |
| Antigravity | `.agent/rules` → `.agents/rules` | `.agents/skills` | — | Plugin "Dart and Flutter" (Settings → Customizations) |
| Codex | `AGENTS.md` | `.agents/skills` | — | `~/.codex/config.toml` |
| Cursor | `.cursor/rules/*.mdc` | `.cursor/skills` | — | `.cursor/mcp.json` |
| Copilot | `.github/copilot-instructions.md` | `.github/skills` | — | `.vscode/mcp.json` |

Las carpetas por agente son **enlaces** a `.agents/` (los crea `tool/setup_ai.sh`):
una sola fuente de verdad.

## Flujo de una feature

```
/new-feature kinetix wishlist
  flutter-architect      → docs/ai/specs/kinetix-wishlist.md   (spec, solo lectura)
  flutter-feature-slice  → domain → data → provider → pantalla → l10n
  flutter-test-engineer  → tests con package:checks + @Preview
  flutter-auditor + flutter-a11y-auditor → hallazgos antes del merge
```

## Ramas de la demo

| Rama | Contenido |
|---|---|
| `main` / `step-0-workspace` | Workspace + Kinetix sin la feature Wishlist |
| `step-1-domain` | Spec + contrato del repositorio + datasource mock |
| `step-2-ui` | Estados sellados, provider, pantalla, botón ♥ |
| `final` | Previews EN/ES + tests (27 en verde) |

`git checkout step-2-ui` si te quedas atrás.

## `package:skills` vs `flutter/agent-plugins` vs `dart-lang/skills`

- **`flutter/agent-plugins`**: plugin oficial (Claude, Cursor, Codex) con 10
  skills Flutter + 15 Dart + config del MCP.
- **`dart-lang/skills`**: las skills de Dart (el plugin ya las incluye).
- **`package:skills`**: el **instalador**: `dart run skills@ add <repo-git>` o
  `dart run skills@ get` (skills que traen tus dependencias). Aquí se usó para
  dejar 23 oficiales versionadas en `.agents/skills/` para cualquier agente
  (quitamos 2 que no aplican a apps: CLI y compilación de C/C++; ver `.agents/skills-exclude.txt`).
  Actualizar: `tool/setup_ai.sh --update` y revisar `git diff`.

## Créditos

Reglas `flutter-*` y skills oficiales: [flutter/agent-plugins](https://github.com/flutter/agent-plugins)
(BSD-3-Clause). Documentación: [docs.flutter.dev/ai](https://docs.flutter.dev/ai/get-started).
