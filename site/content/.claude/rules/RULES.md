# Rules

Markdown files that provide [contextual conventions](^Loaded into context only when relevant, based on file patterns you define) Claude loads automatically. Each rule is a `.md` file in `.claude/rules/`. When Claude reads files matching a rule's [path patterns](^Standard glob syntax: * matches files, ** matches directories, {a,b} matches alternatives), that rule is loaded into context alongside your CLAUDE.md.

## Quick Start

1. Create a file: `.claude/rules/code-style.md`
2. Optionally add [frontmatter](^A YAML block at the top of the file between --- markers. Contains the paths field to scope rules to specific files) with `paths` to scope it to specific files
3. Write your conventions in the body
4. Commit to version control so your team shares the same rules

No registration or configuration needed. Claude discovers rule files automatically at startup.

## How Rules Work

Rules use a simple matching model:

1. **Discovery**: At startup, Claude scans `.claude/rules/` [recursively](^All .md files are discovered in subdirectories too, so you can organise rules into folders like frontend/ or backend/) and reads each file's frontmatter
2. **Matching**: When Claude reads a file, it checks which rules have matching `paths` patterns. If multiple rules match, all of them are loaded
3. **Loading**: Matched rules are pulled into context alongside CLAUDE.md. Rules with no `paths` are always loaded

## Frontmatter

Rules optionally use YAML frontmatter to control when they activate:

```yaml
---
paths:
  - "src/**/*.ts"
  - "src/**/*.py"
---
```

| Field | Required | Purpose |
|---|---|---|
| `paths` | No | File patterns that trigger this rule. Omit to always load |

If you omit frontmatter entirely, the rule is always loaded into context with the same priority as CLAUDE.md.

## Where Rules Live

| Location | Scope |
|---|---|
| `.claude/rules/` | This project (check into version control) |
| `~/.claude/rules/` | All your projects |

User-level rules load before project rules, giving project rules higher priority. The `.claude/rules/` directory also supports [symlinks](^Symbolic links are resolved and loaded normally. Circular symlinks are detected and handled gracefully), so you can maintain a shared set of rules and link them into multiple projects.

## Rules vs CLAUDE.md vs Skills

| | CLAUDE.md | Rules | Skills |
|---|---|---|---|
| When loaded | Every session, always | When Claude reads matching files | When relevant to the current task |
| Purpose | Project-wide context | File-scoped conventions | Reusable instructions and actions |
| Invocable | No | No | Yes (with `/skill-name`) |
| Supporting files | No | No | Yes (scripts/, references/, assets/) |
| Frontmatter | No | Optional (`paths`) | Required (name, description) |

Use **CLAUDE.md** for project-wide context that always applies. Use **rules** for conventions that only matter when working on specific file types. Use **skills** for actions Claude performs on demand.

## Common Patterns

**Language-specific style guides**: one rule per language with paths targeting that file type. Python conventions load only when Claude reads `.py` files.

**Testing conventions**: testing patterns that activate only when working in test files. Keeps test-specific rules out of context during normal development.

**Error handling**: error conventions scoped to source files. How to report errors, what to log, what to surface to users.

**Security rules**: input validation, authentication, and dependency policies scoped to relevant files.

**Documentation standards**: comment style, docstring format, and README conventions scoped to the files they apply to.

## Tips

- Keep rules focused. One concern per file, not one giant file with everything
- Use descriptive filenames: `code-style.md`, `testing.md`, `error-handling.md`
- Keep individual rule files concise. Every loaded rule consumes context window tokens alongside CLAUDE.md
- Rules with no `paths` are always loaded, so use them sparingly to avoid context bloat
- Rules are passive context. If you need Claude to run scripts or follow multi-step workflows, use a [skill](^Skills are reusable instruction packages with optional scripts, references, and invocation via /skill-name) instead
- Rules complement CLAUDE.md. Put universal conventions in CLAUDE.md, file-specific conventions in rules
- Organise rules into subdirectories (e.g. `rules/frontend/`, `rules/backend/`) for larger projects. All `.md` files are discovered recursively

## Explore the Scaffolding

Open the `my-rule.md` file below to see a complete example rule with every field and pattern explained.

[Rules documentation](https://code.claude.com/docs/en/memory)
