-- Minimal native Neovim session management
-- Global session directory: ~/.local/share/nvim/sessions/
-- Session naming: project-name-md5hash.vim (MD5 hash of full project path)

---@type any
local log = require('packages.session_manager.log')

---@type any
local utils = require('packages.session_manager.utils')
---@type any
local save = require('packages.session_manager.save')
---@type any
local load = require('packages.session_manager.load')
---@type any
local tmux = require('packages.session_manager.tmux')
---@type any
local terminal = require('packages.session_manager.terminal')

log.info('Session Manager initialized with session directory: ' .. utils.session_dir)

-- Initialize auto-save on plugin load
save.setup_auto_save()

-- Initialize auto-load on startup
load.setup_auto_load()
