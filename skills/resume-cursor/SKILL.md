---
name: resume-cursor
description: >
  Resume or continue work from a recent Cursor CLI or Cursor Desktop session.
  Use when the user switched from Cursor, says "continue from Cursor" or
  "resume my Cursor session", or names a Cursor session by description, path,
  or native ID.
metadata:
  short-description: "Continue from a recent Cursor session"
argument-hint: "[words describing the session | session id]"
---

Set `TOOL=cursor`.

The skill directory is the folder containing this `SKILL.md` (Grok / Claude
Code: `${SKILL_DIR}`). Set `SHARED_DIR` to `../shared/resume-session`
relative to that folder. It must contain `CORE.md` and `session_reader.py`.

Read and follow `${SHARED_DIR}/CORE.md`. Use the user's optional session
reference unchanged (`$ARGUMENTS` when the host provides slash-command
args; otherwise the prompt text).
