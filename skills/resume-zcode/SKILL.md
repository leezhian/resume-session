---
name: resume-zcode
description: >
  Resume or continue work from a recent ZCode session. Use when the user
  switched from ZCode, says "continue from ZCode" or "resume my ZCode session",
  or names a ZCode session by description, path, or native ID (sess_...).
metadata:
  short-description: "Continue from a recent ZCode session"
argument-hint: "[words describing the session | session id]"
---

Set `TOOL=zcode`.

The skill directory is the folder containing this `SKILL.md` (Grok / Claude
Code: `${SKILL_DIR}`). Set `SHARED_DIR` to `../shared/resume-session`
relative to that folder. It must contain `CORE.md` and `session_reader.py`.

Read and follow `${SHARED_DIR}/CORE.md`. Use the user's optional session
reference unchanged (`$ARGUMENTS` when the host provides slash-command
args; otherwise the prompt text).
