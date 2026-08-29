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

- **pre-commit** — staged `.md` files must have valid YAML frontmatter (`fecha_creacion`, `estado`, `categoria`). Excludes `Templates/`, `CLAUDE.md`, `README.md`.
- **commit-msg** — message must match `^(feat|fix|docs|expand|refactor|chore)(\(.+\))?: ` and be ≤72 chars. Use `expand:` for growing existing notes, `chore:` for infra (hooks/scripts). This is a hard requirement — a plain "Update x.md" won't commit.
- **pre-push** — all wikilinks `[[X]]` must resolve to an existing note filename. Note: index/MoC files, `Log.md`, `Scripts del Vault.md`, `Templates/`, `CLAUDE.md`/`README.md` are excluded from the check.

Run the same checks manually without committing:

```bash
./scripts/check-frontmatter.sh            # validate all notes (--fix, --solo-errores, or per-folder)
./scripts/find-orphans.sh                 # notes not linked from the MoC
./scripts/vault-stats.sh --resumen        # up-to-date stats
./scripts/add-modification-date.sh        # sync fecha_modificacion with mtime
```

## Conventions an agent will get wrong

- **Frontmatter is mandatory on every content note** (`fecha_creacion`, `fecha_modificacion`, `estado`, `categoria`, `prioridad`). Only `README.md`, `CLAUDE.md`, and index/log notes may omit parts (see CLAUDE.md §3). Maintain 12 fixed categories; unknown categories fail validation.
- **`fecha_modificacion`** is updated by `add-modification-date.sh` (perl, mtime-based) — a pre-commit hook does not do it for you. Update it when hand-editing a note with substantial changes.
- **Update `10 - Automatización y Scripts/Log.md`** (append, never rewrite) after any vault work; keep `00 - Indices y Mapas/TODO.md` current.
- **Link new notes from the MoC** (`00 - Indices y Mapas/MoC - Linux.md`) and use wikilinks `[[Nota]]`. Broken wikilinks block push.
- **Do not store images locally** — use external URLs (`upload.wikimedia.org` / official sites).
- **Filenames**: no spaces-breaking references — avoid `#`/`...`/`:` patterns in filenames (the pre-push regex treats those specially). Keep filenames basic.
- **Scanner quirks**: use `find ...` pipelines rather than tools that choke on thousands of `.md` files. Scripts were optimized (vault-stats ~0.16s, find-orphans ~6s); don't regress that.

## Structure at a glance

`00` indices/MoC · `01-05` concepts/system/DEs/WMs · `07` one note per command · `08` programs · `09` troubleshooting · `10` automation/scripts/Log · `11` distros · `Templates/` (don't alter structure without asking) · `scripts/` bash validation/automation.
