-- Notify buffer that captures vim.notify output
local M = {}

local notify_buf = nil
local original_notify = vim.notify
local notify_history = {}

local LEVELS = {
  [vim.log.levels.TRACE] = 'TRACE',
  [vim.log.levels.DEBUG] = 'DEBUG',
  [vim.log.levels.INFO] = 'INFO',
  [vim.log.levels.WARN] = 'WARN',
  [vim.log.levels.ERROR] = 'ERROR',
}

function M.get_buf()
  return notify_buf
end

local function format_time()
  return os.date('%H:%M:%S')
end

local function get_level_name(level)
  return LEVELS[level] or 'INFO'
end

function M.render()
  if not notify_buf or not vim.api.nvim_buf_is_valid(notify_buf) then
    return
  end

  local lines = {}
  for _, entry in ipairs(notify_history) do
    local level = get_level_name(entry.level)
    table.insert(lines, string.format('[%s] [%s] %s', entry.time, level, entry.message))
  end

  vim.api.nvim_buf_set_lines(notify_buf, 0, -1, false, lines)
end

function M.append(message, level)
  level = level or vim.log.levels.INFO

  local entry = {
    time = format_time(),
    level = level,
    message = message,
  }

  table.insert(notify_history, entry)

  if notify_buf and vim.api.nvim_buf_is_valid(notify_buf) then
    local line_idx = #notify_history - 1
    local level_name = get_level_name(level)
    local new_line = string.format('[%s] [%s] %s', entry.time, level_name, message)
    vim.api.nvim_buf_set_lines(notify_buf, line_idx, line_idx + 1, false, { new_line })
  end
end

function M.open()
  if not notify_buf or not vim.api.nvim_buf_is_valid(notify_buf) then
    notify_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(notify_buf, 'notify://')
    vim.api.nvim_set_option_value('buftype', 'nofile', { buf = notify_buf })
    vim.api.nvim_set_option_value('filetype', 'notify', { buf = notify_buf })
    vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = notify_buf })

    M.render()
  end

  vim.cmd('split')
  vim.api.nvim_set_current_buf(notify_buf)
end

function M.toggle()
  if notify_buf and vim.api.nvim_buf_is_valid(notify_buf) then
    local current = vim.api.nvim_get_current_buf()
    if current == notify_buf then
      vim.cmd('close')
      return
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == notify_buf then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end

  M.open()
end

function M.clear()
  notify_history = {}
  if notify_buf and vim.api.nvim_buf_is_valid(notify_buf) then
    vim.api.nvim_buf_set_lines(notify_buf, 0, -1, false, {})
  end
end

local function wrapped_notify(message, level, opts)
  M.append(message, level)
  original_notify(message, level, opts)
end

function M.setup()
  vim.notify = wrapped_notify

  vim.api.nvim_create_user_command('NotifyToggle', M.toggle, {})
  vim.api.nvim_create_user_command('NotifyClear', M.clear, {})
  vim.api.nvim_create_user_command('NotifyTest', function()
    vim.notify('Test notify at ' .. os.date('%H:%M:%S'), vim.log.levels.INFO)
  end, {})
end

return M
