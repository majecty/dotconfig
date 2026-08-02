-- Terminal restart functionality for Neovide
local log = require('packages.session_manager.log')
local save = require('packages.session_manager.save')

local M = {}

--- Restart with neovide
function M.neovide_restart()
  local cwd = vim.fn.getcwd()
  save.save_session()
  vim.cmd('sleep 100m')
  local cmd = "cd '" .. cwd:gsub("'", "'\\''") .. "' && /home/juhyung/.cargo/bin/neovide > /dev/null 2>&1 &"
  log.info('Starting Neovide: ' .. cmd)
  os.execute(cmd)
  vim.cmd('qa!')
end

--- Determine split direction based on window size
---@return string split_direction 'vsplit' or 'split'
local function get_split_direction()
  local width = vim.o.columns
  local height = vim.o.lines
  if width > height then
    return 'vsplit'
  else
    return 'split'
  end
end

--- Reconnect a single non-tmux terminal buffer in the same window
---@param buf BufferHandle Buffer handle
---@param winid WindowHandle Window ID
local function reconnect_terminal_buffer(buf, winid)
  log.info('Reconnecting non-tmux terminal buffer in window: ' .. tostring(winid))

  local ok, err = pcall(vim.api.nvim_buf_delete, buf, { force = true })
  if not ok then
    log.warn('Failed to delete non-tmux terminal buffer: ' .. tostring(err))
    return
  end

  local win_valid = pcall(vim.api.nvim_win_is_valid, winid)
  if not win_valid then
    log.warn('Window is no longer valid after buffer deletion: ' .. tostring(winid))
    return
  end

  local ok2, err2 = pcall(vim.api.nvim_win_call, winid, function()
    vim.cmd('terminal')
    log.info('New shell opened in same window')
  end)

  if not ok2 then
    log.warn('Failed to open shell in window: ' .. tostring(err2))
    local ok3, err3 = pcall(function()
      local split_dir = get_split_direction()
      vim.cmd(split_dir .. ' | terminal')
      log.info('New shell opened in new ' .. split_dir .. ' (fallback)')
    end)
    if not ok3 then
      log.error('Failed to open shell in split (fallback): ' .. tostring(err3))
    end
  end
end

--- Reconnect non-tmux terminal buffers after session load
function M.reconnect_non_tmux_terminals()
  log.debug('reconnect_non_tmux_terminals: Starting')

  local tabs = vim.api.nvim_list_tabpages()
  log.debug('Found ' .. #tabs .. ' tabs')

  for _, tabpage in ipairs(tabs) do
    if not vim.api.nvim_tabpage_is_valid(tabpage) then
      log.debug('Tab ' .. tostring(tabpage) .. ' is no longer valid, skipping')
      goto continue_tab
    end

    local windows = vim.api.nvim_tabpage_list_wins(tabpage)
    log.debug('Tab ' .. tostring(tabpage) .. ' has ' .. #windows .. ' windows')

    for _, winid in ipairs(windows) do
      if not vim.api.nvim_win_is_valid(winid) then
        log.debug('Window ' .. tostring(winid) .. ' is no longer valid, skipping')
        goto continue_win
      end

      local ok, buf = pcall(vim.api.nvim_win_get_buf, winid)
      if not ok then
        log.debug('Failed to get buffer for window ' .. tostring(winid) .. ', skipping')
        goto continue_win
      end

      local bufname = vim.api.nvim_buf_get_name(buf)
      log.trace('Checking buffer in tab ' .. tostring(tabpage) .. ' window ' .. tostring(winid) .. ': ' .. bufname)

      if bufname:match('^term://') and not bufname:match('tmux%s+attach%-session') then
        reconnect_terminal_buffer(buf, winid)
      end

      ::continue_win::
    end

    ::continue_tab::
  end

  log.debug('reconnect_non_tmux_terminals: Completed')
end

return M
