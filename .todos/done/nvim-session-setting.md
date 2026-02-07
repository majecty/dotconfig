# session setting for nvim

**Status:** Done
**Date:** 2026-02-08

## Details
- Implemented minimal native Neovim session management (no plugins)
- Auto-detects project name from directory containing .git
- Saves/loads: buffers, cursor position, folds, marks, terminal buffers, window sizes
- **Session switching with UI:**
  - `<leader>ss`: Save session (auto project name)
  - `<leader>sl`: Load session from list picker (shows all saved sessions)
- **Directory switching:** pwd changes to project directory when loading session
- Sessions stored in ~/.config/nvim/sessions/

## Notes
Minimal, robust implementation using Neovim's built-in :mksession command.
Session picker allows easy switching between multiple project sessions.
Working directory automatically updates to project root when loading.

