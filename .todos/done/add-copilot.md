# add copilot

**Status:** Done
**Date:** 2026-02-08

## Details
- Added github/copilot.vim plugin with minimal config
- Configured copilot accept keymap with vim.keymap.set() in copilot.lua
- Added keymap to whichkey for <C-j> accept in insert mode
- Set vim.g.copilot_no_tab_map = true to disable default tab completion

## Notes
- Copilot accepts suggestions with <C-J> in insert mode
- Works with expr = true and replace_keycodes = false
- Minimal configuration following lazy.nvim pattern
