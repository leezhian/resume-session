# resume-session

Resume Claude Code, Codex, Cursor, Qoder CLI, or Grok work as **untrusted inert
history**. One skill tree, several install surfaces so Claude, Codex,
OpenCode, Pi, Grok, and Cursor can all load it.

This does **not** auto-install into any agent. Pick a method below.

## What you get

| Skill | When to use |
| --- | --- |
| `resume-claude` | Continue a Claude Code session |
| `resume-codex` | Continue a Codex CLI / VS Code session |
| `resume-cursor` | Continue a Cursor CLI / Desktop session |
| `resume-qoder` | Continue a Qoder CLI session (JSONL under `~/.qoder/projects`) |
| `resume-grok` | Continue a Grok session (`~/.grok/sessions/<encoded-cwd>/<id>/`) |

Shared reader: `skills/shared/resume-session/session_reader.py`.

## Layout

```
.claude-plugin/plugin.json      # Claude Code plugin
.claude-plugin/marketplace.json
.codex-plugin/plugin.json       # Codex plugin
.agents/plugins/marketplace.json
.grok-plugin/plugin.json        # Grok plugin
.grok-plugin/marketplace.json
package.json                    # Pi: pi.skills
install.sh                      # skill-dir install for every agent
skills/
  resume-claude/SKILL.md
  resume-codex/SKILL.md
  resume-cursor/SKILL.md
  resume-qoder/SKILL.md
  resume-grok/SKILL.md
  shared/resume-session/
    CORE.md
    session_reader.py
```

`${SKILL_DIR}/../shared/resume-session` is the portable reader path. The
installer always places `shared/` next to the four skills.

OpenCode has **skills**, not a skill-plugin format. Its "plugin" system is
npm/JS hooks. Use `install.sh` or copy into a skill directory.

## 1. Universal skill install (recommended)

Copies or symlinks skills into each agent's skill root. Canonical store is
the vendor-neutral `.agents/skills` path (Codex, Pi, OpenCode, Copilot,
Gemini all read it). Extra vendor dirs are linked so Claude / Grok / Cursor
see the same files.

```bash
cd /path/to/skill-demo
chmod +x install.sh

# user-wide (default: symlink)
./install.sh --user

# this repo only
./install.sh --project /path/to/your-repo

# Claude + Codex agent dirs only, copied not linked
./install.sh --user --copy --agents claude,codex

# only resume-qoder and resume-grok (shared/ is always included)
./install.sh --user --skills qoder,grok

# remove only those two skills
./install.sh --user --skills qoder,grok --uninstall

# remove every skill this package installed
./install.sh --user --uninstall
```

| Agent | User skill dir | Project skill dir |
| --- | --- | --- |
| All (canonical) | `~/.agents/skills/` | `.agents/skills/` |
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Codex | `~/.codex/skills/` | `.codex/skills/` |
| OpenCode | `~/.config/opencode/skills/` | `.opencode/skills/` |
| Pi | `~/.pi/agent/skills/` | `.pi/skills/` |
| Grok | `~/.grok/skills/` | `.grok/skills/` |
| Cursor | `~/.cursor/skills/` | `.cursor/skills/` |

Then start a **new** agent session. Invoke `/resume-qoder`, `/resume-grok`,
`/resume-claude`, or say "continue from Qoder" / "continue from Grok".

`npx skills add .` can also discover `skills/*/SKILL.md`, but it may skip
`shared/`. Prefer `install.sh` so the reader stays a sibling of each skill.

## 2. Native plugin / package install

Use these when you want the host's plugin manager, not skill-dir copies.
Each command is **opt-in**; nothing here runs them for you.

### Claude Code

```bash
# marketplace pointing at this folder
claude plugin marketplace add /path/to/skill-demo
claude plugin install resume-session
```

Or pass the plugin directory into a session (`--plugin-dir /path/to/skill-demo`).

### Codex

```bash
codex plugin marketplace add /path/to/skill-demo
# then install resume-session from /plugins
```

Manifest: `.codex-plugin/plugin.json`. Catalog: `.agents/plugins/marketplace.json`.

### Grok

```bash
grok plugin marketplace add /path/to/skill-demo
grok plugin install resume-session --trust
grok plugin enable resume-session
```

Or `grok plugin install /path/to/skill-demo --trust` (copies into
`~/.grok/installed-plugins/`; update later with `grok plugin update`).

### Pi

```bash
pi install /path/to/skill-demo
```

`package.json` declares `"pi": { "skills": ["./skills"] }`. Pi also loads
`~/.agents/skills/` and `.agents/skills/`, so `install.sh` covers Pi without
`pi install`.

### OpenCode

No SKILL.md plugin package. After `install.sh`, OpenCode loads:

- `.opencode/skills/<name>/SKILL.md`
- `~/.config/opencode/skills/`
- `.agents/skills/` and `.claude/skills/` (compat)

## Smoke test

```bash
python3 skills/shared/resume-session/session_reader.py qoder list --cwd "$PWD" --json
python3 skills/shared/resume-session/session_reader.py grok list --cwd "$PWD" --json
python3 skills/shared/resume-session/session_reader.py claude list --cwd "$PWD" --json
python3 skills/shared/resume-session/session_reader.py codex list --cwd "$PWD" --json
```

Qoder IDE transcripts are out of scope (phase 1 is CLI JSONL only).
