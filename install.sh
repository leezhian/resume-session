#!/usr/bin/env bash
# Install resume-session skills for Claude Code, Codex, OpenCode, Pi, Grok, Cursor, ZCode, Antigravity.
# Does not call any agent plugin installer.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="${ROOT}/skills"
ALL_SKILLS=(resume-claude resume-codex resume-cursor resume-qoder resume-grok resume-zcode resume-antigravity)

SCOPE="user"
MODE="link"
ACTION="install"
AGENTS="all"
SKILLS="all"

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Installs selected resume-* skills plus the shared reader into each agent's
skill directory. Does not run grok/claude/codex/pi plugin install.

Options:
  --user            User-wide install (default)
  --project [DIR]   Project install; DIR defaults to the current working directory
  --copy            Copy files instead of symlinking
  --link            Symlink into agent dirs (default)
  --agents LIST     Where to install: grok,claude,codex,opencode,pi,cursor,zcode,antigravity,all
  --skills LIST     Which skills: resume-claude,resume-codex,resume-cursor,
                    resume-qoder,resume-grok,resume-zcode,resume-antigravity,all
                    Short names also work: claude,codex,cursor,qoder,grok,zcode,antigravity,agy
  --uninstall       Remove selected skill names from selected agent dirs
  -h, --help        Show this help

shared/ is always installed with any skill (the reader lives there).
On uninstall, shared/ is removed only when no resume-* skill from this
package remains in that directory.

Canonical store:
  user     ~/.agents/skills
  project  <dir>/.agents/skills

Vendor dirs then point at that store so ${SKILL_DIR}/../shared/resume-session
keeps working.
EOF
}

die() {
  echo "error: $*" >&2
  exit 1
}

PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user) SCOPE="user"; shift ;;
    --project)
      SCOPE="project"
      if [[ $# -ge 2 && "$2" != -* ]]; then
        PROJECT_DIR="$2"
        shift 2
      else
        shift
      fi
      ;;
    --copy) MODE="copy"; shift ;;
    --link) MODE="link"; shift ;;
    --agents)
      [[ $# -ge 2 ]] || die "--agents requires a value"
      AGENTS="$2"
      shift 2
      ;;
    --skills)
      [[ $# -ge 2 ]] || die "--skills requires a value"
      SKILLS="$2"
      shift 2
      ;;
    --uninstall) ACTION="uninstall"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown option: $1" ;;
  esac
done

if [[ "$SCOPE" == "user" ]]; then
  CANON="${HOME}/.agents/skills"
  PREFIX="${HOME}"
else
  if [[ -n "$PROJECT_DIR" ]]; then
    PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
  else
    PROJECT_DIR="$(pwd)"
  fi
  CANON="${PROJECT_DIR}/.agents/skills"
  PREFIX="$PROJECT_DIR"
fi

agent_wanted() {
  local name="$1"
  [[ "$AGENTS" == "all" ]] && return 0
  IFS=',' read -r -a parts <<< "$AGENTS"
  local part
  for part in "${parts[@]}"; do
    [[ "$part" == "$name" ]] && return 0
  done
  return 1
}

normalize_skill() {
  local raw="$1"
  raw="${raw// /}"
  case "$raw" in
    all) echo "all" ;;
    resume-claude|claude) echo "resume-claude" ;;
    resume-codex|codex) echo "resume-codex" ;;
    resume-cursor|cursor) echo "resume-cursor" ;;
    resume-qoder|qoder) echo "resume-qoder" ;;
    resume-grok|grok) echo "resume-grok" ;;
    resume-zcode|zcode) echo "resume-zcode" ;;
    resume-antigravity|antigravity|agy) echo "resume-antigravity" ;;
    shared) echo "shared" ;;
    *) die "unknown skill: $raw (use resume-claude, resume-codex, resume-cursor, resume-qoder, resume-grok, resume-zcode, resume-antigravity)" ;;
  esac
}

resolve_selection() {
  SELECTED_SKILLS=()
  if [[ "$SKILLS" == "all" ]]; then
    SELECTED_SKILLS=("${ALL_SKILLS[@]}")
    return
  fi
  local raw name seen=""
  IFS=',' read -r -a parts <<< "$SKILLS"
  for raw in "${parts[@]}"; do
    [[ -n "$raw" ]] || continue
    name="$(normalize_skill "$raw")"
    if [[ "$name" == "all" ]]; then
      SELECTED_SKILLS=("${ALL_SKILLS[@]}")
      return
    fi
    [[ "$name" == "shared" ]] && continue
    if [[ " ${seen} " != *" ${name} "* ]]; then
      SELECTED_SKILLS+=("$name")
      seen="${seen} ${name}"
    fi
  done
  [[ ${#SELECTED_SKILLS[@]} -gt 0 ]] || die "--skills matched no skills"
}

other_package_skill_present() {
  local dest="$1"
  local keep="$2"
  local name
  for name in "${ALL_SKILLS[@]}"; do
    [[ " ${keep} " == *" ${name} "* ]] && continue
    if [[ -e "${dest}/${name}" || -L "${dest}/${name}" ]]; then
      return 0
    fi
  done
  return 1
}

# vendor dests are extra skill roots besides the canonical .agents/skills store
vendor_dests() {
  if [[ "$SCOPE" == "user" ]]; then
    agent_wanted grok && echo "${PREFIX}/.grok/skills"
    agent_wanted claude && echo "${PREFIX}/.claude/skills"
    agent_wanted codex && echo "${PREFIX}/.codex/skills"
    agent_wanted opencode && echo "${PREFIX}/.config/opencode/skills"
    agent_wanted pi && echo "${PREFIX}/.pi/agent/skills"
    agent_wanted cursor && echo "${PREFIX}/.cursor/skills"
    agent_wanted zcode && echo "${PREFIX}/.zcode/skills"
    agent_wanted antigravity && echo "${PREFIX}/.gemini/antigravity-cli/skills"
  else
    agent_wanted grok && echo "${PREFIX}/.grok/skills"
    agent_wanted claude && echo "${PREFIX}/.claude/skills"
    agent_wanted codex && echo "${PREFIX}/.codex/skills"
    agent_wanted opencode && echo "${PREFIX}/.opencode/skills"
    agent_wanted pi && echo "${PREFIX}/.pi/skills"
    agent_wanted cursor && echo "${PREFIX}/.cursor/skills"
    agent_wanted zcode && echo "${PREFIX}/.zcode/skills"
    agent_wanted antigravity && echo "${PREFIX}/.gemini/skills"
  fi
}

place_item() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  if [[ "$MODE" == "link" ]]; then
    ln -sfn "$src" "$dest"
  else
    cp -R "$src" "$dest"
  fi
}

remove_item() {
  local dest="$1"
  if [[ -e "$dest" || -L "$dest" ]]; then
    rm -rf "$dest"
  fi
}

resolve_selection
INSTALL_NAMES=("${SELECTED_SKILLS[@]}" shared)

if [[ "$ACTION" == "install" ]]; then
  [[ -d "$SKILLS_SRC" ]] || die "missing ${SKILLS_SRC}"
  mkdir -p "$CANON"
  for name in "${INSTALL_NAMES[@]}"; do
    src="${SKILLS_SRC}/${name}"
    [[ -d "$src" ]] || die "missing ${src}"
    place_item "$src" "${CANON}/${name}"
  done
  echo "canonical: ${CANON} (${MODE}) [${INSTALL_NAMES[*]}]"

  while IFS= read -r dest; do
    [[ -n "$dest" ]] || continue
    mkdir -p "$dest"
    for name in "${INSTALL_NAMES[@]}"; do
      place_item "${CANON}/${name}" "${dest}/${name}"
    done
    echo "linked: ${dest}"
  done < <(vendor_dests)
else
  KEEP="${SELECTED_SKILLS[*]}"
  for dest in "$CANON" $(vendor_dests); do
    [[ -d "$dest" ]] || continue
    for name in "${SELECTED_SKILLS[@]}"; do
      remove_item "${dest}/${name}"
    done
    if ! other_package_skill_present "$dest" "$KEEP"; then
      remove_item "${dest}/shared"
    fi
    echo "removed names from: ${dest}"
  done
fi
