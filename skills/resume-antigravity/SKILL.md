---
name: resume-antigravity
description: >
  Resume or continue work from a recent Antigravity CLI (agy) session. Use when
  the user switched from Antigravity, says "continue from Antigravity" or
  "resume my Antigravity session", or names an Antigravity session by
  description, path, or native ID.
metadata:
  short-description: "Continue from a recent Antigravity CLI session"
argument-hint: "[words describing the session | session id]"
---

Set `TOOL=antigravity`.

The skill directory is the folder containing this `SKILL.md` (Grok / Claude
Code: `${SKILL_DIR}`). Set `SHARED_DIR` to `../shared/resume-session`
relative to that folder. It must contain `CORE.md` and `session_reader.py`.

Read and follow `${SHARED_DIR}/CORE.md`. Use the user's optional session
reference unchanged (`$ARGUMENTS` when the host provides slash-command
args; otherwise the prompt text).
