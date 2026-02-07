# session setting for nvim

**Status:** Done
**Date:** 2026-02-08

## Details
- Implemented minimal native Neovim session management (no plugins)
- Auto-detects project name from directory containing .git
- Saves/loads: buffers, cursor position, folds, marks, terminal buffers, window sizes
- Added keybindings in which-key:
  - `<leader>ss`: Save session (auto project name)
  - `<leader>sl`: Load session (auto project name)

## Notes
Minimal, robust implementation using Neovim's built-in :mksession command.
Sessions stored in ~/.config/nvim/sessions/
Project name auto-detection from .git directory makes it reliable and easy to use.

