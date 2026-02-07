# Add Stylua Lua Formatter

**Status:** Done
**Date:** 2026-02-08

## Details
- Installed stylua (Lua formatter) via cargo: `cargo install stylua`
- Created `stylua.toml` configuration in ~/jhconfig
- Configured to use 2 spaces (no tabs), Unix line endings, single quotes
- Integrated into workflow: format all nvim lua files before committing

## Changes
- Installed: `/home/juhyung/.cargo/bin/stylua`
- Created: `/home/juhyung/jhconfig/stylua.toml`
- All nvim lua files formatted with stylua
- Memory updated: "Auto-format nvim lua files with stylua before commit"

## Configuration
```toml
indent_type = "Spaces"
indent_width = 2
line_endings = "Unix"
quote_style = "AutoPreferSingle"
```

## Notes
- Runs automatically before every commit on nvim lua files
- Command: `stylua /home/juhyung/jhconfig/nvim/lua/`
- Ensures consistent code style across all nvim configuration
