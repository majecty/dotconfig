# Reconnect Non-Tmux Terminal Buffers on Session Load

**Status:** Done
**Date:** 2026-08-02

## Details

- Added `reconnect_non_tmux_terminals()` to `nvim/lua/packages/session_manager/terminal.lua`
- After session load, non-tmux terminal buffers are replaced with a fresh shell in the same window
- Same fallback split logic as tmux terminal reconnection
- Updated `nvim/lua/packages/session_manager/load.lua` to call both tmux and non-tmux reconnection

## Notes

- tmux attach-session terminals are still handled separately by `tmux.lua`
- Uses current working directory (cwd) after session load, so shell opens in the project directory
