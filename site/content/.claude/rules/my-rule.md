---
paths:
  - "src/**/*.ts"
  - "src/**/*.py"
---

# Source Code Conventions

Extends CLAUDE.md with patterns specific to application source files.

## Error Handling
- Always use the project's error types, never throw raw strings or generic errors
- Log detailed context server-side, return only safe messages to callers
- Catch errors at boundaries (API handlers, event listeners), not deep in utility code

## Naming
- Functions that return booleans start with `is`, `has`, or `should`
- Constants use UPPER_SNAKE_CASE, variables and functions use camelCase or snake_case per language convention
- File names match their primary export: `UserService` lives in `user-service.ts` or `user_service.py`

## Imports and Dependencies
- Group imports: standard library first, external packages second, internal modules third
- No circular imports. If two modules need each other, extract the shared logic into a third
- Prefer explicit imports over wildcards

---

This is a starter rule file. The filename `my-rule.md` is just an example. Name your rules descriptively: `backend-api.md`, `testing.md`, `frontend-react.md`.

## Anatomy of This File

The **frontmatter** (between the `---` markers at the top) is optional but recommended. It controls when this rule loads:

- `paths`: file patterns that trigger this rule. When Claude reads a file matching any of these patterns, this rule is loaded into context

If you omit the frontmatter entirely (or omit `paths`), the rule is always loaded, behaving like an extension of CLAUDE.md.

The **body** contains your actual conventions. Write them as direct instructions. Bullet lists and short headers work best because Claude scans structure the same way a developer does.

## Path Pattern Examples

| Pattern | Matches |
|---|---|
| `"src/**/*.ts"` | All TypeScript files under src/ |
| `"**/*.test.{ts,js}"` | Test files at any depth |
| `"src/**/*.py"` | Python files in the src directory |
| `"docker-compose*.yml"` | Docker Compose files in the project |
| `"**/*.sql"` | All SQL files anywhere in the project |

## What Goes in a Rule vs CLAUDE.md

Put conventions in a **rule file** when they:
- Apply only to specific file types or directories
- Would add noise for developers working on other parts of the codebase
- Are detailed enough to bloat CLAUDE.md if included inline

Keep conventions in **CLAUDE.md** when they:
- Apply universally (naming, git workflow, PR process)
- Are short enough that splitting them out adds more overhead than it saves
- Need to be visible at all times regardless of what files Claude is reading

## Rules vs Skills

Rules and [skills](^Skills are reusable instruction packages with SKILL.md, optional scripts, references, and invocation via /skill-name) both provide instructions, but they solve different problems:

| | Rules | Skills |
|---|---|---|
| Format | Markdown with optional `paths` frontmatter | SKILL.md with required name/description frontmatter |
| Purpose | Passive conventions loaded into context | Active instructions, optionally invocable |
| Activation | Automatic, based on file patterns | Automatic or via `/skill-name` |
| Supporting files | None (just the .md file) | scripts/, references/, assets/ |
| Side effects | Never | Can run commands and modify files |

Use rules for "always follow these patterns when reading these files." Use skills for "here is how to perform this specific task."

## Real-World Examples

Teams commonly create rules like:

- `backend-api.md` with paths scoped to controller files: error handling, auth patterns, response formats
- `testing.md` with paths scoped to test directories: test structure, mock patterns, assertion conventions
- `database.md` with paths scoped to data access code: ORM patterns, migration rules, query conventions
- `frontend-react.md` with paths scoped to component files: state management, styling, accessibility patterns
- `infrastructure.md` with paths scoped to Docker/CI files: security settings, deployment checklists
