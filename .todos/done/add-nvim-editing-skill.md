# Add Nvim Editing Skill

**Status:** Done
**Date:** 2026-02-08

## Details
- Created nvim-editing skill for standardized nvim config editing workflow
- Skill located in `~/.opencode/skills/nvim-editing/SKILL.md`
- Defines workflow: edit → format → health check → commit
- Ensures consistent practices when modifying nvim configuration files

## Workflow Steps

1. **Edit** - Make changes to nvim lua files using Edit tool
2. **Format** - Run stylua to format the changes
3. **Health Check** - Verify with `nvim --headless -c 'checkhealth'`
4. **Commit** - Commit with descriptive message

## Guidelines Included

- Always format before committing
- Test with health check for errors
- Use descriptive commit messages
- One concern per commit (no mixing changes)
- Update memory if new patterns emerge

## Usage

Load with: `skill nvim-editing`

Automatically activated when editing nvim config files in:
- `~/.config/nvim/lua/`
- `/home/juhyung/jhconfig/nvim/lua/`

## Notes

- Integrates with existing stylua formatter
- Works with which-key keymap best practices
- Ensures all nvim edits follow established patterns
