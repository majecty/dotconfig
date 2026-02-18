-- Minimal native Neovim session management
-- Global session directory: ~/.local/share/nvim/sessions/
-- Session naming: project-name-md5hash.vim (MD5 hash of full project path)

---@type PlenaryLogger
local log = require('packages.session_manager.log')

---@type SessionManagerUtils
local utils = require('packages.session_manager.utils')
---@type SessionManagerSave
local save = require('packages.session_manager.save')
---@type SessionManagerLoad
local load = require('packages.session_manager.load')
---@type SessionManagerTmux
local tmux = require('packages.session_manager.tmux')
---@type SessionManagerTerminal
local terminal = require('packages.session_manager.terminal')

log.info('Session Manager initialized with session directory: ' .. utils.session_dir)

-- Initialize auto-save on plugin load
save.setup_auto_save()

-- Initialize auto-load on startup
load.setup_auto_load()
