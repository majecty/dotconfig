# install typescript language server

**Status:** Done
**Date:** 2026-02-08

## Details
- Installed typescript-language-server via npm
- Configured LSP using new vim.lsp.config() API (not deprecated lspconfig)
- Set proper absolute path to typescript-language-server binary
- Reduced LSP log level to 'info' for better performance
- Fixed TypeScript/JavaScript language support in Neovim

## Notes
- Uses modern Neovim LSP API instead of deprecated lspconfig framework
- Absolute path ensures consistent binary resolution
- Verified via :checkhealth command
