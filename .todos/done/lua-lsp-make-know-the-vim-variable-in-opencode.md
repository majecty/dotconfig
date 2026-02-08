# lua lsp make know the vim variable in opencode

**Status:** Done
**Date:** 2026-02-08

## Details
- Created `.luarc.json` in project root for general Lua config
- Created `nvim/.luarc.json` for Neovim-specific Lua config
- Added "vim" to diagnostics.globals so Lua LSP recognizes vim variable
- Configured LuaJIT runtime and workspace libraries

## Notes
- Lua LSP now provides autocomplete and type hints for vim.* API
- Works in OpenCode and Neovim editor
- Both root and nvim directories have separate configs for flexibility
- checkThirdParty set to false to avoid warnings
