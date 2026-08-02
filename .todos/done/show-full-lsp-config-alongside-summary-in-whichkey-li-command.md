# Show full LSP config alongside summary in whichkey li command

**Status:** Done
**Date:** 2026-08-02

## Details

Updated the `<leader>li` binding in `nvim/lua/plugins/whichkey.lua` to show both a concise summary and the full registered configuration for each active LSP client.

- For each attached client, it prints the client name, custom mode label, and root directory.
- Then it prints the full config returned by `vim.lsp.config.get(client.name)`.
- The output is available through `:messages`.

## Notes

- Custom mode labels are currently resolved for `rust_analyzer` and `rust_analyzer_rustc`.
- Validation passed with `stylua --check` and `nvim checkhealth lsp`.
