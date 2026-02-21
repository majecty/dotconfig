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
- **When ordered to complete tasks:** Remove completed [x] items from TODO.md and ensure corresponding done files exist in `.todos/done/`
- After removing done items and adding done files, commit changes with message "remove done todo items, add done files"

# User Preferences (from recent sessions)

- Update, commit, and push after every completed config or workflow change.
- Minimal, modular Neovim config—feature-based, file-per-plugin structure.
- Only use explanations when asked; keep confirmations brief.
- Conversational, turn-by-turn, single-question workflow for Autotodo mode.
- **Communicate in Korean** - Use Korean for all user interactions and responses
- **All configs managed from ~/jhconfig directory** (nvim and others symlinked/referenced there)
- **OpenCode configs and skills are in ~/jhconfig/.opencode/** (skills, SKILL.md files)

# Learning from Recent Sessions

## Code Organization Principles
- NEVER use global variables (_G) - Always use require() modules
- whichkey.lua ONLY for keymaps - Never define functions there
- One concern per file - Functions in respective modules (packages/)
- Absolute paths for executables - Relative paths cause bugs
- ALWAYS add LuaCATS comments for type annotations

## Validation Process
- Always run :checkhealth after LSP changes
- Run stylua --check before commits
- Test with nvim --headless -c 'checkhealth'

# How to Manage This Memory File

- **Location:** `.github/instructions/memory.instruction.md`
- **Auto-loaded:** Via `.opencode.yaml` on every OpenCode run
- **How to update:** 
  - Add new preferences/rules to "User Preferences" section
  - Always commit changes with descriptive messages
  - Keep sections organized: Autotodo Essentials → Session Workflow → User Preferences → How to Manage
- **Review before adding:** Ask user for approval before updating memory
- **Format:** Markdown with clear sections and bullet points

