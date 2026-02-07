# nvim Close and Reopen with Same Session

**Status:** Done
**Date:** 2026-02-08

## Details
- Added `<leader>sr` which-key keybind to close nvim and reopen with neovide (GUI)
- Saves session before closing using `_G.nvim_session.save()`
- Closes all nvim instances with `qa!`
- Reopens with neovide GUI using `os.execute("neovide &")`
- When neovide opens in same project, session auto-loads via VimEnter autocmd

## Changes
- Added keybind in `/home/juhyung/jhconfig/nvim/lua/plugins/whichkey.lua`
- New mapping: `<leader>sr` → "Save session and reopen with GUI"
- Installed neovide from cargo: `cargo install neovide`

## Notes
- Uses neovide (GUI nvim) for better window management
- Session auto-loads on neovide reopen in the same project directory
- All buffers, folds, and cursor positions are preserved
- The `&` backgrounds the neovide process so terminal is freed up
