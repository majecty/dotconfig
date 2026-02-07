# Install Neovide GUI

**Status:** Done
**Date:** 2026-02-08

## Details
- Installed neovide (GUI for Neovim) via cargo: `cargo install neovide`
- Created desktop shortcut for application launcher
- Integrated with session reload feature (`<leader>sr`)
- Neovide appears in system application menu

## Changes
- Installed: `/home/juhyung/.cargo/bin/neovide`
- Created: `~/.local/share/applications/neovide.desktop`
- Updated which-key keybind `<leader>sr` to reopen with neovide GUI

## Desktop Entry
```
[Desktop Entry]
Version=1.0
Type=Application
Name=Neovide
Comment=GUI for Neovim
Exec=neovide %F
Icon=nvim
Categories=Utility;TextEditor;Development;
Terminal=false
```

## Notes
- Neovide provides better window management for session reload workflow
- Session auto-loads on startup via VimEnter autocmd
- Works seamlessly with existing session system
