---
name: nvim-editing
description: Skill for editing nvim configuration files - handles formatting, testing, and committing changes.
---

# Nvim Editing Skill

Use this skill whenever you edit nvim lua configuration files in `/home/juhyung/jhconfig/nvim/lua/`.

## Activation

Automatically activate for any substantive nvim config changes. Not needed for trivial single-line edits.

## Workflow

### 1. Edit the File
- Make the necessary changes to the nvim lua file
- Use the Edit tool to modify the file

### 2. Format with Stylua
After editing, always run stylua to format:
```bash
stylua /home/juhyung/jhconfig/nvim/lua/plugins/[filename].lua
```
Or for all files:
```bash
stylua /home/juhyung/jhconfig/nvim/lua/
```

### 3. Health Check
Run nvim health check to ensure no errors:
```bash
nvim --headless -c 'checkhealth' -c 'quit'
```

### 4. Commit Changes
Commit the formatted changes with a descriptive message:
```bash
git add -A && git commit -m "[message describing the change]"
```

## Guidelines

- **Always format before committing** - Run stylua on edited files
- **Test with health check** - Ensure nvim loads without errors
- **Descriptive commits** - Explain what was added/changed and why
- **One concern per commit** - Don't mix unrelated changes
- **Update memory if needed** - If adding new keybind patterns or preferences

## Architecture Principles

### Module Organization
- **Plugin files** (`nvim/lua/plugins/`): Plugin setup and configuration only
- **Package files** (`nvim/lua/packages/`): Shared functionality and utilities
- **No global variables**: Use `require()` to import modules instead of `_G`

### Function Placement
- **whichkey.lua**: 
  - Only keymap definitions using `wk.add()`
  - Call functions from modules via `require()`
  - NO function definitions or complex logic
- **Plugin/Package files**: 
  - Function implementations
  - Helper functions
  - Module exports via `return M`

### Module Pattern
Create modules for complex functionality:
```lua
-- nvim/lua/packages/my_feature/init.lua
local M = {}

function M.do_something()
  -- implementation
end

function M.setup()
  -- initialization
end

return M
```

Then in whichkey:
```lua
local my_feature = require('packages.my_feature')
-- Use my_feature.do_something() in keymaps
```

## Which-key Best Practices

- **Always use which-key for new keybinds** (not direct keybinds)
- **Use which-key groups for multi-key sequences** (e.g., `<leader>s` group for `<leader>ss`, `<leader>sl`, `<leader>sr`)
- Use `wk.add()` API (new version, not deprecated `register()`)
- Always add group names with `group = '+name'` for grouping
- Keep related keymaps together in logical groups
- **Import modules at top of config function** for cleaner code

## LSP Configuration

- Use `vim.lsp.config()` (new API) instead of `require('lspconfig').SERVER.setup()` (deprecated)
- Example: `vim.lsp.config('ts_ls', { cmd = {...} })`
- Enable with: `vim.lsp.enable('ts_ls')`
- Check deprecation warnings in `:checkhealth`

## Stylua Configuration

Stylua is configured in `~/jhconfig/stylua.toml`:
```toml
indent_type = "Spaces"
indent_width = 2
line_endings = "Unix"
quote_style = "AutoPreferSingle"
```

- Always run stylua on nvim lua files before committing
- Formats with 2 spaces (no tabs), Unix line endings, single quotes
- Command: `stylua /home/juhyung/jhconfig/nvim/lua/`

## Example

```
📝 Editing nvim config: whichkey.lua

[Make edits with Edit tool]

✅ Formatted with stylua
✅ Health check passed
✅ Committed: "add new keymap for X"
```

## Common Tasks

- **Add keymaps**: Use which-key, call functions from modules
- **Update plugins**: Modify plugin spec files in `nvim/lua/plugins/`
- **Add functions**: Create module in `nvim/lua/packages/`
- **Change settings**: Edit config options in plugin files
- **Fix bugs**: Debug and test before committing
