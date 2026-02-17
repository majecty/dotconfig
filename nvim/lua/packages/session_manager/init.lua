-- Minimal native Neovim session management
-- Global session directory: ~/.local/share/nvim/sessions/
-- Session naming: project-name-md5hash.vim (MD5 hash of full project path)

local log = require('packages.session_manager.log')

local utils = require('packages.session_manager.utils')
local save = require('packages.session_manager.save')
local load = require('packages.session_manager.load')

log.info('Session Manager initialized with session directory: ' .. utils.session_dir)

-- Initialize auto-save on plugin load
save.setup_auto_save()

-- Initialize auto-load on startup
load.setup_auto_load()
