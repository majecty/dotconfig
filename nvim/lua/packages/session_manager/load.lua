-- Session load functionality
local log = require('packages.session_manager.log')
local utils = require('packages.session_manager.utils')
local tmux = require('packages.session_manager.tmux')

local M = {}

--- Load session from file path
---@param session_filename string Session file name without extension
---@param display_name string Display name for the session
function M.load_session_from_file(session_filename, display_name)
  local session_path = utils.session_dir .. '/' .. session_filename .. '.vim'
  log.info('Loading session from: ' .. session_path)

  if vim.fn.filereadable(session_path) ~= 1 then
    log.warn('Session not found: ' .. display_name)
    return
  end

  -- Get project path from mapping
  local project_path = utils.get_project_path(session_filename)

  -- Try to change to project directory
  if project_path and vim.fn.isdirectory(project_path) == 1 then
    vim.cmd('cd ' .. project_path)
    log.info('Changed directory to: ' .. project_path)
  end

  log.info('before source session: ' .. session_path)
  local ok, err = pcall(vim.cmd, 'source ' .. session_path)
  if not ok then
    log.error('Failed to load session: ' .. display_name .. ' - ' .. tostring(err))
    vim.notify('Failed to load session: ' .. tostring(err), vim.log.levels.ERROR)
    return
  end

  log.info('Session loaded: ' .. display_name)
  -- Reconnect tmux terminal buffers
  vim.schedule(function()
    tmux.reconnect_tmux_terminals()
  end)
end

--- Load session with picker
function M.load_session_with_picker()
  local sessions = utils.list_sessions()

  if #sessions == 0 then
    log.warn('No sessions found')
    return
  end

  -- Use vim.ui.select which now defaults to fzf-lua
  vim.ui.select(sessions, { prompt = 'Sessions> ' }, function(choice)
    if not choice then
      return
    end

    local ok, err = pcall(function()
      M.load_session_from_file(choice, choice)
    end)
    if not ok then
      log.error('Error loading session: ' .. tostring(err))
      vim.notify('Error loading session: ' .. tostring(err), vim.log.levels.ERROR)
    end
  end)
end

--- Setup auto-load session on startup if it exists (silently)
function M.setup_auto_load()
  local group = vim.api.nvim_create_augroup('NvimSessionAutoLoad', { clear = true })

  -- Auto-load on VimEnter (when opening nvim)
  vim.api.nvim_create_autocmd('VimEnter', {
    group = group,
    callback = function()
      -- Only auto-load if in a git directory
      local project_info = utils.get_project_info()

      -- Early return if not in a git directory
      if vim.fn.isdirectory(project_info.path .. '/.git') ~= 1 then
        log.warn('Not in git directory: ' .. project_info.path)
        return
      end

      local session_filename = utils.get_session_filename(project_info)
      local session_path = utils.session_dir .. '/' .. session_filename .. '.vim'

      -- Early return if session file doesn't exist
      if vim.fn.filereadable(session_path) ~= 1 then
        log.warn('No session found at: ' .. session_path)
        return
      end

      log.info('Loading session: ' .. session_filename)
      local ok, err = pcall(vim.cmd, 'source ' .. session_path)
      if not ok then
        log.error('Failed to load session on startup: ' .. tostring(err))
        return
      end

      log.info('Session loaded successfully on startup: ' .. session_filename)

      -- Reconnect tmux terminal buffers
      vim.schedule(function()
        tmux.reconnect_tmux_terminals()
      end)
    end,
    once = true, -- Only run once on startup
  })
end

return M
