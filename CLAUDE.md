# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

An interactive educational website that teaches Claude Code features by simulating a project you explore. Static HTML/CSS/JS — zero build steps, no framework, no bundler.

## Serving Locally

```bash
# Any static server, pointed at the site/ directory
npx serve site
python -m http.server -d site 8080
```

Opening `site/index.html` directly also works (fetches manifest via relative path).

## Architecture

All educational content is stored as JSON strings inside `site/data/manifest.json`. This single file drives the entire UI — tree structure, file content, labels, badges, and feature groupings. To add or change content, edit the manifest.

**Component classes (all vanilla JS, no modules, loaded via `<script>` tags):**

- `App` (app.js) — Controller. Loads manifest, wires components, handles keyboard nav (arrow keys), hash routing, traffic light buttons, and the void easter egg (minimize button → canvas particle animation).
- `FileExplorer` (file-explorer.js) — Sidebar tree. Draws connector lines (├── └──) on `<canvas>` elements inside `.tree-children-guided` containers. `.claude` is auto-expanded on load.
- `ContentLoader` (content-loader.js) — Renders file content. Has a hand-rolled markdown parser supporting: YAML frontmatter (rendered as tables), fenced code blocks, tables, lists, inline formatting, and links. Markdown files get a Rendered/Raw toggle. Syntax highlighting via Prism.js.
- `Terminal` (terminal.js) — Right-side panel. Interactive slash command emulator (`/help`, `/init`, `/doctor`, `/diff`, `/compact`, `/model`, `/cost`, `/status`, `/config`, `/memory`). Animated output sequences.
- `ProgressTracker` (progress.js) — Tracks visited features in localStorage under key `tcc-progress`.

**CSS is split by concern:** `variables.css` (design tokens), `layout.css` (shell/sidebar/content grid), `components.css` (tree items, badges, content panels, frontmatter), `syntax.css` (Prism overrides), `terminal.css`, `void.css` (easter egg).

## Critical Invariants

**Canvas DPI scaling:** `_createCanvas()` in file-explorer.js already calls `ctx.scale(dpr, dpr)`. Callers must never scale the context again or tree connector lines will misalign on high-DPI displays (coordinates get multiplied by dpr²).

**Static tree line timing:** The `.claude` directory is auto-expanded on load. `_drawStaticLines` uses double `requestAnimationFrame` to ensure the browser has completed layout before measuring `offsetTop`/`getBoundingClientRect`. If the zero-dimension guard triggers, it retries on the next frame.

**Frontmatter handling:** The markdown renderer detects `---` fenced blocks at the start of content and renders them as styled tables. Without this, `---` becomes `<hr>` and YAML `#` comments render as headings.

**Manifest node schema:** Each tree node has `name`, `path`, `type` ("file"|"directory"). Files can have: `content` (markdown/code string), `feature` (groups related files), `badge`, `label`, `description`, `command`. Directories have `children` array.

## Content Design Principles

- Content should feel like exploring a real repo — self-describing boilerplate that explains itself
- Concise overview for scanning, with depth available for those who want it
- Each `.claude/` subfolder has a grounding entry-point file (e.g., `SKILLS.md`) outside the scaffolding, then the scaffolding demonstrates the actual structure
