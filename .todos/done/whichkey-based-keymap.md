# Whichkey-based Keymap Setup

**Status:** Done
**Date:** 2026-02-08

## Details
- Refactored all keymaps to use which-key for centralized management
- Migrated from deprecated `register()` API to new `add()` API
- Organized keymaps into logical groups with proper naming conventions
- Added support for split navigation, file operations, session management, and fzf search

## Keymaps Implemented

### Session Management (`<leader>s`)
- `<leader>ss` - Save session
- `<leader>sl` - Load session from list
- `<leader>sr` - Reload with neovide GUI

### Window Management (`<leader>w`)
- `<leader>ww` - Equalize split sizes
- `<C-h/j/k/l>` - Navigate between splits

### File Operations (`<leader>f`)
- `<leader>ff` - Find files with fzf-lua
- `<leader>E` - Open file for editing

### Jump/UI (`<leader>j`)
- `<leader>jo` - Open jhui buffer
- `<leader>jr` - Reload jhui plugin

## Changes
- `/home/juhyung/jhconfig/nvim/lua/plugins/whichkey.lua` - Complete refactor
- Uses which-key `add()` API (latest version)
- All multi-key sequences properly grouped
- Consistent naming with `+` prefix for groups

## Configuration
- Stylua formatter configured for Lua files (2 spaces, no tabs)
- All files formatted before commit
- Which-key groups clearly labeled and organized

## Notes
- Fixed `<leader>w` conflict (was both action and group, now only group)
- Renamed `<leader>jh` to `<leader>j` for cleaner naming
- Using which-key groups consistently as per new guidelines
