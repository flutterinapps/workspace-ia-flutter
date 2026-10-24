@AGENTS.md

## Claude Code

Claude Code no lee `AGENTS.md` por sí solo: esta línea lo importa. Las reglas
de siempre se importan aquí para que entren en el contexto desde el inicio:

@.agents/rules/team-workflow.md
@.agents/rules/team-architecture.md
@.agents/rules/team-design-system.md
@.agents/rules/team-a11y-inclusion.md
@.agents/rules/team-usage-report.md
@.agents/rules/flutter-code-quality.md
@.agents/rules/flutter-dart-flutter-best-practices.md
@.agents/rules/flutter-testing.md
@.agents/rules/flutter-hot-reload.md

- Skills: `.claude/skills` → `.agents/skills`. Agentes: `.claude/agents` → `.agents/agents`.
- `/new-feature <app> <feature>` ejecuta `.agents/workflows/new-feature.md`.
- Un hook formatea y analiza cada archivo `.dart` que edites (`.claude/settings.json`).
