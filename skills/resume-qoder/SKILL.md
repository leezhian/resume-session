---
name: resume-qoder
description: >
  Resume or continue work from a recent Qoder CLI session. Use when the user
  switched from Qoder, says "continue from Qoder" or "resume my Qoder session",
  or names a Qoder session by description, path, or native ID.
metadata:
  short-description: "Continue from a recent Qoder CLI session"
argument-hint: "[words describing the session | session id]"
---

Set `TOOL=qoder`.

The skill directory is the folder containing this `SKILL.md` (Grok / Claude
Code: `${SKILL_DIR}`). Set `SHARED_DIR` to `../shared/resume-session`
relative to that folder. It must contain `CORE.md` and `session_reader.py`.

Read and follow `${SHARED_DIR}/CORE.md`. Use the user's optional session
reference unchanged (`$ARGUMENTS` when the host provides slash-command
args; otherwise the prompt text).
