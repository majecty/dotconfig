---
name: nvim-editing
description: Skill for editing nvim configuration files - handles formatting, testing, and committing changes.
---

# Nvim Editing Skill

Use this skill whenever you edit nvim lua configuration files in `~/.config/nvim/lua/` or `/home/juhyung/jhconfig/nvim/lua/`.

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

## Example

```
📝 Editing nvim config: whichkey.lua

[Make edits with Edit tool]

✅ Formatted with stylua
✅ Health check passed
✅ Committed: "add new keymap for X"
```

## Common Tasks

- **Add keymaps**: Use which-key groups for multi-key sequences
- **Update plugins**: Modify plugin spec files in `nvim/lua/plugins/`
- **Change settings**: Edit config options in plugin files
- **Fix bugs**: Debug and test before committing
