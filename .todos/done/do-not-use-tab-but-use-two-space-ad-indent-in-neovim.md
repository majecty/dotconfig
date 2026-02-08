# do not use tab but use two space ad indent in neovim

**Status:** Done
**Date:** 2026-02-08

## Details
- Configured Neovim to use spaces instead of tabs for indentation
- Set indent size to 2 spaces
- Added to nvim/lua/packages/settings/init.lua

## Settings Applied
- vim.opt.expandtab = true (convert tabs to spaces)
- vim.opt.tabstop = 2 (display width of tab)
- vim.opt.softtabstop = 2 (spaces when pressing Tab)
- vim.opt.shiftwidth = 2 (auto-indent size)

## Notes
- All new files will use 2-space indentation
- Tab key inserts 2 spaces instead of tab character
- Applies globally to all files in Neovim
- Consistent with stylua formatter settings
