-- Session load functionality
local log = require('packages.session_manager.log')
local utils = require('packages.session_manager.utils')

local M = {}

-- Process a single tmux terminal buffer (helper)
local function process_tmux_buffer(buf, bufname)
  -- Check if buffer is a terminal with tmux attach command
  if not bufname:match('term://.*tmux%s+attach%-session') then
    return
  end

  log.info('Found tmux terminal buffer: ' .. bufname)

  -- Extract session name from buffer name
  local session_name = bufname:match('tmux%s+attach%-session%s+%-t%s+([%w_-]+)')
  log.debug('Extracted session name: ' .. (session_name or 'nil'))

  if not session_name then
    log.warn('Could not extract session name from: ' .. bufname)
    return
  end

  -- Check if tmux session exists
  local check_cmd = 'tmux has-session -t ' .. session_name .. ' 2>/dev/null'
  log.debug('Checking tmux session with: ' .. check_cmd)
  local result = os.execute(check_cmd)
  log.debug('tmux check result: ' .. tostring(result))

  if result ~= 0 then
    log.warn('tmux session does not exist: ' .. session_name)
    return
  end

  log.info('Session exists, reconnecting: ' .. session_name)
  -- Session exists, replace terminal buffer with new terminal
  vim.api.nvim_buf_call(buf, function()
    -- Delete the dead terminal and create new one
    local winid = vim.fn.bufwinid(buf)
    log.debug('Window ID: ' .. tostring(winid))
    if winid <= 0 then
      log.warn('Window not found for buffer')
      return
    end

    vim.api.nvim_win_call(winid, function()
      log.debug('Deleting old terminal buffer')
      vim.cmd('bdelete!')
      log.debug('Creating new tmux terminal')
      vim.cmd('split | terminal tmux attach-session -t ' .. session_name)
      vim.cmd('resize 15')
      log.info('Terminal reconnected: ' .. session_name)
    end)
  end)
end

-- Reconnect tmux terminals after session load
function M.reconnect_tmux_terminals()
  log.debug('reconnect_tmux_terminals: Starting')
  local buf_list = vim.api.nvim_list_bufs()
  log.debug('Found ' .. #buf_list .. ' buffers')

  for _, buf in ipairs(buf_list) do
    local bufname = vim.api.nvim_buf_get_name(buf)
    log.trace('Checking buffer: ' .. bufname)
    process_tmux_buffer(buf, bufname)
  end
  log.debug('reconnect_tmux_terminals: Completed')
end

-- Load session from file path
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
    M.reconnect_tmux_terminals()
  end)
end

-- Load session with picker
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

-- Load session for current project
function M.load_session()
  local project_info = utils.get_project_info()
  local session_filename = utils.get_session_filename(project_info)
  local session_path = utils.session_dir .. '/' .. session_filename .. '.vim'

  if vim.fn.filereadable(session_path) ~= 1 then
    log.warn('No session found for: ' .. project_info.name)
    return
  end

  local ok, err = pcall(function()
    M.load_session_from_file(session_filename, project_info.name)
  end)
  if not ok then
    log.error('Error loading session: ' .. tostring(err))
    vim.notify('Error loading session: ' .. tostring(err), vim.log.levels.ERROR)
  end
end

-- Auto-load session on startup if it exists
function M.auto_load_session()
  local project_info = utils.get_project_info()
  local session_filename = utils.get_session_filename(project_info)
  local session_path = utils.session_dir .. '/' .. session_filename .. '.vim'

  if vim.fn.filereadable(session_path) ~= 1 then
    return
  end

  local ok, err = pcall(vim.cmd, 'source ' .. session_path)
  if not ok then
    log.error('Failed to auto-load session: ' .. tostring(err))
  end
end

-- Setup auto-load session on startup if it exists (silently)
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
      else
        log.info('Session loaded successfully on startup: ' .. session_filename)
      end
    end,
    once = true, -- Only run once on startup
  })
end

return M
