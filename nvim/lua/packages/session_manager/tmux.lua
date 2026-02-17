-- Tmux integration for session manager
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

-- Attach to tmux session
function M.tmux_attach()
  local project_info = utils.get_project_info()
  local session_name = project_info.name

  -- Create tmux session if it doesn't exist
  local cmd = 'tmux has-session -t '
    .. session_name
    .. ' 2>/dev/null || tmux new-session -d -s '
    .. session_name
    .. ' -c '
    .. project_info.path
  os.execute(cmd)

  -- Open terminal at bottom
  vim.cmd('split | terminal tmux attach-session -t ' .. session_name)
  vim.cmd('resize 15')
end

return M
