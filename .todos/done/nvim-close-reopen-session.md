# nvim Close and Reopen with Same Session

**Status:** Done
**Date:** 2026-02-08

## Details
- Added `<leader>sr` which-key keybind to close nvim and reopen with neovide (GUI)
- Saves current working directory before closing
- Saves session with `_G.nvim_session.save()`
- Waits 100ms to ensure session file is written
- Reopens neovide in the same directory: `cd <dir> && neovide &`
- Closes nvim with `qa!`
- When neovide opens in same project, session auto-loads via VimEnter autocmd

## Changes
- Updated `/home/juhyung/jhconfig/nvim/lua/plugins/whichkey.lua`
- Mapping: `<leader>sr` → "Save session and reopen with GUI"
- Installed neovide: `cargo install neovide`
- Created desktop shortcut: `~/.local/share/applications/neovide.desktop`

## Tested
- ✅ Keybind closes and reopens neovide successfully
- ✅ Session persists across reopen
- ✅ All buffers and cursor positions preserved

## Notes
- Small delay (100ms) ensures session file is fully written before reopen
- Directory context preserved so session loads correctly
- Neovide appears in application launcher as well
