# Add rust-analyzer LSP config with general/rustc workspace detection

**Status:** Done
**Date:** 2026-08-02

## Details

Added rust-analyzer LSP configuration to `nvim/lua/plugins/lspconfig.lua` that distinguishes between general Rust projects and the `rust-lang/rust` compiler workspace.

- General Rust projects use `rust_analyzer` with default clippy checks.
- `rust-lang/rust` repository uses a separate `rust_analyzer_rustc` config based on the existing coc configuration.
  - Uses `x.py` for check and build-scripts overrides.
  - Links the relevant Cargo.toml files.
  - Configures rustfmt, proc macro server, sysroot source, and server environment variables.
- Added `root_dir` filtering so the two configs do not overlap.
- Mapped `*.fixed`, `*.pp`, and `*.mir` extensions to the `rust` filetype.

## Notes

- The rust-analyzer binary is resolved through the existing Mason helper.
- Validation passed with `stylua --check` and `nvim checkhealth lsp`.
