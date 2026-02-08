# search smartcase in nvim

**Status:** Done
**Date:** 2026-02-08

## Details
- Added smartcase setting for vim search and command
- Configured vim.opt.ignorecase = true for case-insensitive search
- Configured vim.opt.smartcase = true for smart case behavior
- Added to nvim/lua/packages/settings/init.lua

## Notes
- Search with lowercase only: matches any case
- Search with uppercase: case-sensitive matching
- Applies to both search (/) and command (:) mode
