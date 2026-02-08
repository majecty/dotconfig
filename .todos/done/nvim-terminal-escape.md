# Nvim Terminal Escape Keybindings

**Status:** Done
**Date:** 2026-02-08

## Details
- Created new `lua/config/terminal.lua` configuration file
- `Esc` - Exits terminal mode and returns to normal mode (`<C-\><C-n>`)
- `Shift+Esc` - Sends literal Esc character to terminal application
- Imported terminal.lua in init.lua before lazy.nvim setup

## Notes
- Separated terminal configuration into dedicated module for maintainability
- Allows flexible terminal workflow without conflicts
- Works with built-in Neovim terminal (`:terminal`)
