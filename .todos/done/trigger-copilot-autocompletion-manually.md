# trigger copilot autocompletion manually

**Status:** Done
**Date:** 2026-02-08

## Details
- Added manual trigger for Copilot suggestions in insert mode
- Configured <C-k> to trigger/show Copilot suggestion
- Uses copilot#Next() to cycle through suggestions
- Added to nvim/lua/plugins/copilot.lua

## Keymaps
- <C-k> in insert mode - Trigger/show Copilot suggestion
- <C-j> in insert mode - Accept Copilot suggestion (existing)

## Notes
- <C-k> will show Copilot suggestion if available
- If suggestion is already shown, <C-k> cycles to next suggestion
- Works in insert mode only
