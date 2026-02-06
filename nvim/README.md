# Neovim Configuration

## Overview
Personal Neovim configuration with support for multiple environments (standalone, VSCode, Neovide).

## Directory Structure

```
nvim/
├── init.lua              # Main configuration entry point
├── lazy-lock.json        # Lazy.nvim lock file (plugin versions)
├── lua/
│   ├── config/
│   │   ├── lazy.lua      # Lazy.nvim plugin manager setup
│   │   └── plugins/
│   │       └── spec1.lua # Plugin specifications
│   └── user/
│       ├── plugins_always/
│       │   └── other.lua # Universal plugins
│       ├── plugins_notvscode/
│       │   └── a.lua     # Standalone nvim plugins
│       └── plugins_vscode/
│           └── a.lua     # VSCode Neovim plugins
└── jhui/                 # Custom UI plugin (WIP)
    ├── lua/jhui/
    │   ├── config.lua
    │   ├── init.lua
    │   └── main.lua
    └── plugin/jhui.lua
```

## Current Features

### Core Keybindings
- **Leader Key**: Space
- **Config Reload**: `<C-r>` - Reload Neovim config
- **Config Edit**: `<leader>e` - Edit init.lua
- **Window Navigation**: `<C-h/j/k/l>` - Navigate between splits (non-VSCode)
- **Redo**: `U` - Redo last change

### Environment-Specific Settings
- **Neovide** (GUI): macOS keybindings (Cmd+S, Cmd+C/V), colorscheme (unokai), tab/indent settings
- **VSCode**: Minimal setup with clipboard integration
- **Standalone**: Full LSP, plugins, and keybinding support

### LSP Configuration
- **gopls**: Go language server with full settings (codelenses, hints, analyses)
- **lua_ls**: Lua language server with diagnostics disabled globally
- **Inlay Hints**: Enabled for better code understanding
- **Auto-format**: Go files auto-format on save

### Plugin Features
- **fzf-lua**: Fuzzy finder for files, buffers, diagnostics, keymaps, grep
- **Git Integration**: Fugitive-based git commands (`<leader>gg`)
- **Overseer**: Task runner integration (`<leader>o*`)
- **LSP Code Actions**: `<leader>ca` in normal/visual mode
- **Codeium**: AI-powered completions with cycle navigation
- **Plenary.job**: Async job handling for git commit message generation

### Advanced Keybindings
- **`<leader>gm`**: Generate git commit message using aichat
- **`<leader>ff`**: Fuzzy file search
- **`<leader>b`**: Buffer list
- **`<leader>sd`**: Workspace diagnostics
- **`<leader>sD`**: Buffer diagnostics
- **`<leader>h`**: Help tags
- **`<leader>m`**: Keymaps
- **`<leader>gp`**: Grep project
- **`<leader>ww`**: Save file
- **`<leader>wq`**: Save and quit
- **`<C-S-C/V>`**: Copy/paste in all modes (Neovide)
- **`<ESC><ESC>`**: Exit terminal mode

## TODO
- [ ] Organize plugin configuration structure
- [ ] Add Rust analyzer setup
- [ ] Document jhui custom plugin
- [ ] Refactor init.lua into modular config sections

## Known Issues
- jhui plugin is in early WIP stage
- Configuration mixes concerns in init.lua (could benefit from splitting into modules)
