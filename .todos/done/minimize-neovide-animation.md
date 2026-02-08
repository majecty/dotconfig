# minimize neovide animation

**Status:** Done
**Date:** 2026-02-08

## Details
- Created neovide.toml config file in ~/jhconfig/
- Disabled all animations: cursor, scroll, floating window, window
- Set all animation lengths to 0.0
- Disabled cursor trail
- Created symlink from ~/.config/neovide/neovide.toml to ~/jhconfig/neovide.toml

## Settings Applied
- cursor_animation_length = 0.0
- scroll_animation_length = 0.0
- floating_window_animation_length = 0.0
- window_animation_length = 0.0
- cursor_trail_length = 0
- scroll_animation = false

## Notes
- All neovide configs now managed from ~/jhconfig directory
- Changes take effect on next Neovide restart
