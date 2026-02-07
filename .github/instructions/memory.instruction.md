---
applyTo: '**'
---

# Autotodo Essentials

- Always prefer minimal, native solutions. Avoid plugins unless absolutely required.
- Explicit, step-by-step confirmation and review before memory or code updates.
- Config changes: Remove extras, stick to default/native unless otherwise needed.
- All actions (edit, git, push) must be confirmed concisely.
- Memory updates only after user review and approval.

# Session Workflow

- Begin each session by reading TODO.md and recent memory file to recall workflow.
- Present pending TODOs and ask which to tackle next.
- Maintain modular config and centralize leader keymaps with which-key.
- After each task, update TODO.md, mark completed, commit, and push.
- Track big decisions and preferences in memory file for persistent recall.
- Always adapt to recent user requests and structure.

# User Preferences (from recent sessions)

- Update, commit, and push after every completed config or workflow change.
- Minimal, modular Neovim config—feature-based, file-per-plugin structure.
- Only use explanations when asked; keep confirmations brief.
- Conversational, turn-by-turn, single-question workflow for Autotodo mode.
- **Communicate in Korean** - Use Korean for all user interactions and responses
- **All configs managed from ~/jhconfig directory** (nvim and others symlinked/referenced there)
- **OpenCode configs and skills are in ~/jhconfig/.opencode/** (skills, SKILL.md files)

# How to Manage This Memory File

- **Location:** `.github/instructions/memory.instruction.md`
- **Auto-loaded:** Via `.opencode.yaml` on every OpenCode run
- **How to update:** 
  - Add new preferences/rules to "User Preferences" section
  - Always commit changes with descriptive messages
  - Keep sections organized: Autotodo Essentials → Session Workflow → User Preferences → How to Manage
- **Review before adding:** Ask user for approval before updating memory
- **Format:** Markdown with clear sections and bullet points

