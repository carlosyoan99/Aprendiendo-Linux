# AGENTS.md — AprendiendoLinux vault

An Obsidian **Markdown vault** (Spanish), not a code project. No build system, no package manager, no tests. Work happens as prose notes under numbered `NN - Tema/` folders.

## Read first

- `CLAUDE.md` — **authoritative content rules** (structure, frontmatter, categories, note templates, troubleshooting/command note schemas, Log.md registration). Every content edit must comply with it. It overrides anything here.
- `README.md` — stats, folder map, script overview.
- `00 - Indices y Mapas/TODO.md` — current project state before expanding.

## The "test/lint" flow: git hooks + shell scripts

Validation is NOT in `.git/hooks`. It lives in `.githooks/` and only runs if activated:

```bash
git config core.hooksPath .githooks
chmod +x .githooks/*
```

Three hooks enforce invariants on commit/push:

- **pre-commit** — staged `.md` files must have valid YAML frontmatter (`fecha_creacion`, `estado`, `categoria`). Excludes `Templates/`, `CLAUDE.md`, `README.md`, and `AGENTS.md` (root docs are exempt). It also auto-sets `fecha_modificacion: <today>` on staged notes and re-stages them.
- **commit-msg** — message must match `^(feat|fix|docs|expand|refactor|chore)(\(.+\))?: ` and the whole first line must be ≤72 chars. Use `expand:` for growing existing notes, `chore:` for infra (hooks/scripts). This is a hard requirement — a plain "Update x.md" won't commit.
- **pre-push** — all wikilinks `[[X]]` must resolve to an existing note filename. Excluded from the check: the whole `00 - Indices y Mapas/` dir, `TODO.md`, `Prompts de Trabajo.md`, `Log*.md` (live + year archives), `Scripts del Vault.md`, `Templates/`, `.obsidian/`, and root docs (`CLAUDE.md`/`README.md`/`AGENTS.md`).

Run the same checks manually without committing:

```bash
./scripts/check-frontmatter.sh            # validate all notes (--fix, --solo-errores, or per-folder)
./scripts/find-orphans.sh                 # notes not linked from the MoC nor other notes (--moc-only to check just the MoC)
./scripts/vault-stats.sh --resumen        # up-to-date stats
./scripts/add-modification-date.sh        # sync fecha_modificacion with mtime
```

## Conventions an agent will get wrong

- **Frontmatter is mandatory on every content note** (`fecha_creacion`, `fecha_modificacion`, `estado`, `categoria`, `prioridad`). Only `README.md`, `CLAUDE.md`, and index/log notes may omit parts (see CLAUDE.md §3). Maintain 12 fixed categories; unknown categories fail validation.
- **`fecha_modificacion`** — the pre-commit hook sets it to today on every staged note, so no hand-editing when committing. `add-modification-date.sh` (perl, mtime-based) is only needed to bulk-sync dates to real file mtime (e.g. external edits that bypass git).
- **Any note under ~100 lines is a `borrador` by default.** A note only becomes `resuelto` once it has the full template schema (see below) and clearly exceeds 100 lines. If you create or find a note that is short/incomplete, set (or keep) `estado: borrador` — promoting short notes to `resuelto` is a mistake. The template quality bar is ~130–250 lines minimum for `resuelto`.
- **Update `10 - Automatización y Scripts/Log.md`** as a **compact table** after any vault work (one row per session: `Fecha | Sesión | Tipo | Ámbito | Resumen`); put the verbose detail in `00 - Indices y Mapas/TODO.md` (NOTAS), never in the Log. Keep `Log.md` under ~25 rows — rotate older rows to `Log-YYYY.md` (per-year archive) instead of deleting history. Keep `00 - Indices y Mapas/TODO.md` current.
- **Link new notes from the MoC** (`00 - Indices y Mapas/MoC - Linux.md`) and use wikilinks `[[Nota]]`. Broken wikilinks block push.
- **Do not store images locally** — use external URLs (`upload.wikimedia.org` / official sites).
- **Filenames**: no spaces-breaking references — avoid `#`/`...`/`:` patterns in filenames (the pre-push regex treats those specially). Keep filenames basic.
- **Scanner quirks**: use `find ...` pipelines rather than tools that choke on thousands of `.md` files. Scripts were optimized (vault-stats ~0.16s, find-orphans ~6s); don't regress that.

## Commit flow (commit per phase)

Finish a phase of work → **commit it immediately**. Don't accumulate changes for one big commit at the end. `git log` shows this pattern: one `feat:`/`fix:`/`expand:`/`docs:`/`chore:` commit per phase, with the session id when useful (e.g. `fix: ... (v29)`, `expand: ... (v28)`).

- **Message must satisfy the commit-msg hook**: `^(feat|fix|docs|expand|refactor|chore)(\(.+\))?: ` and ≤72 chars. Commit right after the phase's work (crear/expandir/corregir un lote de notas) is validated.
- **Stage explicitly** the files that belong to this phase. **Never `git add -A`** when the worktree holds unfinished work from another task — leave those un-staged.
- Shared index files (`MoC - Linux.md`, `TODO.md`, `Log.md`) are updated by whichever phase touches them; if a shared file mixes several phases, include it in the commit of the phase that wrote it (or ask).
- Before committing, run `git status --short` and confirm only your files are staged; then validate (see *The "test/lint" flow*) before the commit so the hooks pass cleanly.

## Structure at a glance

`00` indices/MoC · `01-05` concepts/system/DEs/WMs · `07` one note per command · `08` programs · `09` troubleshooting · `10` automation/scripts/Log · `11` distros · `Templates/` (don't alter structure without asking) · `scripts/` bash validation/automation.
