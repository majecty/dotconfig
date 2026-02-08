# add toggleterm in neovim

**Status:** Done
**Date:** 2026-02-08

## Details
- Added toggleterm.nvim plugin with VSCode-style configuration
- Configured to toggle terminal with <C-`> (Ctrl+Backtick)
- Horizontal layout (bottom of screen)
- Terminal height set to 20 lines
- Shade terminals disabled for clean look

## Settings Applied
- open_mapping = [[<C-`>]]
- direction = 'horizontal'
- size = 20
- shade_terminals = false

## Notes
- Works exactly like VSCode integrated terminal
- Press <C-`> to show/hide terminal at bottom
- Multiple terminal support with toggleterm
- Terminal is context-aware for each project
