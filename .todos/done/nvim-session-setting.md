# session setting for nvim

**Status:** Done
**Date:** 2026-02-08

## Details
- Implemented minimal native Neovim session management (no plugins)
- Auto-detects project name and path from directory containing .git
- Saves/loads: buffers, cursor position, folds, marks, terminal buffers, window sizes

### Session Management
- **Save:** `<leader>ss` - Save session (auto project name)
- **Load:** `<leader>sl` - Load session from fzf-lua picker (all saved sessions)
- **Auto-save:** On VimLeavePre (exit) and FocusLost (focus change) - silent
- **Auto-load:** On VimEnter (startup) if git directory has saved session - silent

### Global Session Directory
- Sessions stored in: `~/.local/share/nvim/sessions/`
- Session naming: `projectname-md5hash.vim` (resolves naming conflicts for same-name projects)
- Project path mappings stored in `.project_paths` file
- Directory changes to project root when loading session

### Integration
- fzf-lua set as default `vim.ui.select` for all pickers (sessions, LSP, etc.)
- Fuzzy search for session selection
- XDG Base Directory compliant

## Notes
Minimal, robust implementation using Neovim's built-in :mksession command.
No external session plugins - pure native Neovim with autocommands.
Auto-save/load ensures seamless session persistence across edits and focus changes.
Multi-project support with MD5-based naming prevents conflicts.

