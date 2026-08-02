# Add whichkey commands to inspect rust-analyzer LSP config

**Status:** Done
**Date:** 2026-08-02

## Details

Added which-key bindings under the `<leader>l` LSP group to inspect rust-analyzer configurations:

- `<leader>lI` — Print active LSP clients for the current buffer
- `<leader>lc` — Run `:checkhealth lsp`
- `<leader>lA` — Print the registered `rust_analyzer` config
- `<leader>lR` — Print the registered `rust_analyzer_rustc` config

## Notes

- These bindings are defined in `nvim/lua/plugins/whichkey.lua`.
- The output is printed using `vim.inspect` so it appears in `:messages`.
- Validation passed with `stylua --check` and `nvim checkhealth lsp`.
