---
name: resume-claude
description: >
  Resume or continue work from a recent Claude Code session. Use when the user
  switched from Claude Code, says "continue from Claude" or "resume my Claude
  session", or names a Claude session by description, path, or native ID.
metadata:
  short-description: "Continue from a recent Claude Code session"
argument-hint: "[words describing the session | session id]"
---

Set `TOOL=claude`.

The skill directory is the folder containing this `SKILL.md` (Grok / Claude
Code: `${SKILL_DIR}`). Set `SHARED_DIR` to `../shared/resume-session`
relative to that folder. It must contain `CORE.md` and `session_reader.py`.

Read and follow `${SHARED_DIR}/CORE.md`. Use the user's optional session
reference unchanged (`$ARGUMENTS` when the host provides slash-command
args; otherwise the prompt text).
