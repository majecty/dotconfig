# Change Close Window Keybind

**Status:** Done
**Date:** 2026-02-08

## Details
- Changed close window command from `Super+C` to `Super+Shift+C` in hyprland config
- Reduces accidental window closes since `Super+C` is too easy to trigger by mistake
- Updated `/home/juhyung/jhconfig/computers/air/asahi/hyprland.conf` line 239

## Changes
- `bind = $mainMod, C, killactive,` → `bind = $mainMod SHIFT, C, killactive,`

## Notes
- This makes the keybind less error-prone while keeping it accessible
- Aligned with user's preference for safer default keybindings
