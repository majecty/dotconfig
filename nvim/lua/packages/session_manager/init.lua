-- Minimal native Neovim session management
-- Global session directory: ~/.local/share/nvim/sessions/
-- Session naming: project-name-md5hash.vim (MD5 hash of full project path)

---@class SessionManager
---@field save fun(): nil
---@field load fun(): nil
---@field load_picker fun(): nil
---@field auto_save_silent fun(): nil
---@field list fun(): string[]
---@field dir string
---@field get_project_info fun(): ProjectInfo
---@field tmux_attach fun(): nil
---@field neovide_restart fun(): nil

---@class ProjectInfo
---@field name string
---@field path string

local M = {}
local log = require('packages.session_manager.log')

local utils = require('packages.session_manager.utils')
local save = require('packages.session_manager.save')
local load = require('packages.session_manager.load')
local tmux = require('packages.session_manager.tmux')

log.info('Session Manager initialized with session directory: ' .. utils.session_dir)

-- Module functions
M.save = save.save_session
M.load = load.load_session
M.load_picker = load.load_session_with_picker
M.auto_save_silent = save.auto_save_session_silent
M.list = utils.list_sessions
M.dir = utils.session_dir
M.get_project_info = utils.get_project_info
M.tmux_attach = tmux.tmux_attach
M.neovide_restart = tmux.neovide_restart

-- Initialize auto-save on plugin load
save.setup_auto_save()

-- Initialize auto-load on startup
load.setup_auto_load()

return M
