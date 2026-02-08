# fix neovide session restart

**Status:** Done
**Date:** 2026-02-08

## Details
- Fixed <leader>sr keymap to properly restart Neovide with session preservation
- Used absolute path to neovide: /home/juhyung/.cargo/bin/neovide
- Added proper environment variable handling in os.execute()
- Session data now persists through Neovide restart

## Notes
- Keymap defined in whichkey.lua
- Function implemented in session_manager module
- Relative paths were causing issues; absolute path resolved the problem
