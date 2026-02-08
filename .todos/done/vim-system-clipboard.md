# Vim System Clipboard Support

**Status:** Done
**Date:** 2026-02-08

## Details
- Added `vim.opt.clipboard = 'unnamedplus'` to nvim init.lua
- Enables automatic synchronization between Vim's default register and system clipboard
- Now `y` (yank) command copies directly to system clipboard
- `p` (paste) command pastes from system clipboard

## Notes
- Configuration added to init.lua as a native vim option
- No plugins required for this functionality
- Works seamlessly with existing keybindings
