-- Tmux integration for session manager
local log = require('packages.session_manager.log')
local utils = require('packages.session_manager.utils')

local M = {}

-- Process a single tmux terminal buffer in the same tab
local function process_tmux_buffer_in_tab(buf, winid, session_name)
  log.debug('Processing tmux buffer in window ' .. tostring(winid))

  -- Safely delete the old buffer
  local ok, err = pcall(vim.api.nvim_buf_delete, buf, { force = true })
  if not ok then
    log.warn('Failed to delete buffer: ' .. tostring(err))
    return
  end

  -- Verify window is still valid after buffer deletion
  local win_valid = pcall(vim.api.nvim_win_is_valid, winid)
  if not win_valid then
    log.warn('Window is no longer valid after buffer deletion: ' .. tostring(winid))
    return
  end

  log.debug('Creating new tmux terminal in same window')
  local ok2, err2 = pcall(vim.api.nvim_win_call, winid, function()
    vim.cmd('terminal tmux attach-session -t ' .. session_name)
    log.info('Terminal reconnected in same window: ' .. session_name)
  end)

  if not ok2 then
    log.warn('Failed to create terminal in window: ' .. tostring(err2))
  end
end

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
  log.debug('tmux check result: ' .. tostring(result) .. ' (type: ' .. type(result) .. ')')

  -- Handle both Lua 5.1 (number) and Lua 5.2+ (boolean) return values
  local session_exists = false
  if type(result) == 'boolean' then
    session_exists = result
  else
    session_exists = (result == 0)
  end

  if not session_exists then
    log.warn('tmux session does not exist: ' .. session_name)
    return
  end

  log.info('Session exists, reconnecting: ' .. session_name)

  -- Get window for this buffer
  local winid = vim.fn.bufwinid(buf)
  log.debug('Window ID: ' .. tostring(winid))
  if winid <= 0 then
    log.warn('Window not found for buffer')
    return
  end

  process_tmux_buffer_in_tab(buf, winid, session_name)
end

-- Reconnect tmux terminals after session load
function M.reconnect_tmux_terminals()
  log.debug('reconnect_tmux_terminals: Starting')

  -- Iterate through all tabs
  local tabs = vim.api.nvim_list_tabpages()
  log.debug('Found ' .. #tabs .. ' tabs')

  for _, tabpage in ipairs(tabs) do
    log.debug('Processing tab: ' .. tostring(tabpage))

    -- Get windows in this tab
    local windows = vim.api.nvim_tabpage_list_wins(tabpage)
    log.debug('Tab ' .. tostring(tabpage) .. ' has ' .. #windows .. ' windows')

    for _, winid in ipairs(windows) do
      -- Get buffer in this window
      local buf = vim.api.nvim_win_get_buf(winid)
      local bufname = vim.api.nvim_buf_get_name(buf)
      log.trace('Checking buffer in tab ' .. tostring(tabpage) .. ' window ' .. tostring(winid) .. ': ' .. bufname)

      process_tmux_buffer(buf, bufname)
    end
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
