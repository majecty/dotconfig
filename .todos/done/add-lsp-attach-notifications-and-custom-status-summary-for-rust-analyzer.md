# Add LSP attach notifications and custom status summary for rust-analyzer

**Status:** Done
**Date:** 2026-08-02

## Details

Improved rust-analyzer LSP discoverability so the user can tell which configuration is active without reading raw config output.

- Added `LspAttach` autocmd in `nvim/lua/plugins/lspconfig.lua` that shows a notification when a rust-analyzer client attaches:
  - `rust_analyzer` → "General Rust project mode: rust_analyzer attached"
  - `rust_analyzer_rustc` → "rust-lang/rust compiler development mode: rust_analyzer_rustc attached"

- Added `<leader>li` in `nvim/lua/plugins/whichkey.lua` to print a one-line summary for each active LSP client, including the custom mode label and root directory.

## Notes

- The custom mode label is resolved from the client name.
- Validation passed with `stylua --check` and `nvim checkhealth lsp`.
