-- Notify buffer that captures vim.notify output
local M = {}

local notify_buf = nil
local original_notify = vim.notify
local notify_history = {}
local float_win = nil
local float_buf = nil
local close_timer = nil

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

local function close_float()
  if close_timer then
    close_timer:close()
    close_timer = nil
  end
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    vim.api.nvim_win_close(float_win, true)
    float_win = nil
  end
end

local function show_float(message, level)
  close_float()

  if not float_buf or not vim.api.nvim_buf_is_valid(float_buf) then
    float_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = float_buf })
    vim.api.nvim_set_option_value('filetype', 'notify', { buf = float_buf })
  end

  local level_name = get_level_name(level)
  local time = format_time()
  local line = string.format('[%s] [%s] %s', time, level_name, message:gsub('\n', ' '))
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { line })

  local width = math.min(#line + 2, 80)
  local height = 1
  local total_width = vim.o.columns
  local total_height = vim.o.lines
  local row = 1
  local col = math.max(total_width - width - 2, 0)

  local hl_group = 'Normal'
  if level == vim.log.levels.ERROR then
    hl_group = 'ErrorMsg'
  elseif level == vim.log.levels.WARN then
    hl_group = 'WarningMsg'
  end

  float_win = vim.api.nvim_open_win(float_buf, false, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })

  vim.api.nvim_set_option_value('winhl', 'Normal:' .. hl_group .. ',FloatBorder:' .. hl_group, { win = float_win })

  close_timer = assert(vim.uv.new_timer(), "Failed to create timer")
  close_timer:start(3000, 0, vim.schedule_wrap(close_float))
end

---@param message string
---@param level number
---@param opts table
function M.append(message, level, opts)
  level = level or vim.log.levels.INFO

  local entry = {
    time = format_time(),
    level = level,
    message = message,
  }

  table.insert(notify_history, entry)

  if notify_buf == nil then
    notify_buf = M.find_or_create_buffer()
  end

  local line_idx = #notify_history - 1
  local level_name = get_level_name(level)
  local new_line = string.format(
    '[%s] [%s] %s (%s)',
    entry.time,
    level_name,
    message:gsub('\n', ' '),
    vim.inspect(opts):gsub('\n', ' ')
  )
  vim.api.nvim_buf_set_lines(notify_buf, line_idx, line_idx + 1, false, { new_line })

  show_float(message, level)
end

local function find_notify_buffer()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name == 'notify://' then
        return buf
      end
    end
  end
  return nil
end

--- @return BufferHandle
function M.find_or_create_buffer()
  -- Try to find existing notify buffer first
  notify_buf = find_notify_buffer()

  if not notify_buf or not vim.api.nvim_buf_is_valid(notify_buf) then
    notify_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(notify_buf, 'notify://')
    vim.api.nvim_set_option_value('buftype', 'nofile', { buf = notify_buf })
    vim.api.nvim_set_option_value('filetype', 'notify', { buf = notify_buf })
    vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = notify_buf })

    M.render()
  end

  return notify_buf
end

function M.open()
  -- Try to find existing notify buffer first
  notify_buf = M.find_or_create_buffer()

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

---@param message string
---@param level number
---@param opts table
local function wrapped_notify(message, level, opts)
  M.append(message, level, opts)
  -- original_notify(message, level, opts)
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
