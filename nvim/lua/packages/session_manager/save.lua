-- Session save functionality
local log = require('packages.session_manager.log')
local utils = require('packages.session_manager.utils')

local M = {}

-- Save session for current project
function M.save_session()
  local project_info = utils.get_project_info()
  local session_filename = utils.get_session_filename(project_info)
  local session_path = utils.session_dir .. '/' .. session_filename .. '.vim'

  -- Save the session
  vim.cmd('mksession! ' .. session_path)

  -- Store project path mapping
  utils.store_project_path(session_filename, project_info.path)

  log.info('Session saved: ' .. project_info.name)
end

-- Auto-save session silently (no notifications)
function M.auto_save_session_silent()
  local project_info = utils.get_project_info()
  local session_filename = utils.get_session_filename(project_info)
  local session_path = utils.session_dir .. '/' .. session_filename .. '.vim'

  -- Save the session silently
  vim.cmd('mksession! ' .. session_path)

  -- Store project path mapping
  utils.store_project_path(session_filename, project_info.path)
end

-- Setup auto-save on VimLeavePre and FocusLost events
function M.setup_auto_save()
  local group = vim.api.nvim_create_augroup('NvimSessionAutoSave', { clear = true })

  -- Auto-save on VimLeavePre (when exiting nvim)
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    callback = function()
      M.auto_save_session_silent()
    end,
  })

  -- Auto-save on FocusLost (when switching away from nvim)
  vim.api.nvim_create_autocmd('FocusLost', {
    group = group,
    callback = function()
      M.auto_save_session_silent()
    end,
  })
end

return M
