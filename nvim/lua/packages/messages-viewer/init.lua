local M = {}

---@class MessagesViewerState
---@field buf integer|nil
---@field win integer|nil
---@field lines string[]
---@field filtered string[]
---@field filter string|nil

---@type MessagesViewerState
local state = {
  buf = nil,
  win = nil,
  lines = {},
  filtered = {},
  filter = nil,
}

---Fetch current messages as a list of lines.
---@return string[]
local function get_messages()
  return vim.split(vim.fn.execute('messages'), '\n')
end

---Apply the active filter and update the buffer content.
local function apply_filter()
  local lines = state.lines
  if state.filter then
    local filtered = {}
    local pattern = state.filter:lower()
    for _, line in ipairs(lines) do
      if line:lower():find(pattern, 1, true) then
        table.insert(filtered, line)
      end
    end
    state.filtered = filtered
  else
    state.filtered = lines
  end

  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, state.filtered)
  end
end

---Close the floating window if it is still open.
local function close_window()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
  state.buf = nil
end

---Copy the visible buffer contents to the system clipboard.
local function copy_to_clipboard()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end
  local content = table.concat(vim.api.nvim_buf_get_lines(state.buf, 0, -1, false), '\n')
  vim.fn.setreg('+', content)
  vim.notify('Messages copied to clipboard', vim.log.levels.INFO)
end

---Refresh messages from Neovim and re-apply the active filter.
local function refresh()
  state.lines = get_messages()
  apply_filter()
  vim.notify('Messages refreshed', vim.log.levels.INFO)
end

---Save the visible buffer contents to a timestamped file under ~/.todos/done/.
local function save_to_file()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end
  local content = table.concat(vim.api.nvim_buf_get_lines(state.buf, 0, -1, false), '\n')
  local timestamp = os.date('%Y%m%d-%H%M%S')
  local filename = string.format('%s/.todos/done/messages-%s.txt', vim.fn.expand('~'), timestamp)
  local dir = vim.fn.fnamemodify(filename, ':h')
  vim.fn.mkdir(dir, 'p')
  local file, err = io.open(filename, 'w')
  if file then
    file:write(content)
    file:close()
    vim.notify('Saved to ' .. filename, vim.log.levels.INFO)
  else
    vim.notify('Failed to save messages: ' .. tostring(err), vim.log.levels.ERROR)
  end
end

---Create the floating window and wire buffer-local keymaps.
local function create_window()
  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(30, math.max(10, #state.filtered + 2), vim.o.lines - 4)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, state.filtered)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' messages ',
    title_pos = 'center',
  })

  state.buf = buf
  state.win = win

  vim.keymap.set('n', 'q', close_window, { buffer = buf, nowait = true, silent = true, desc = 'Close viewer' })
  vim.keymap.set('n', '<Esc>', close_window, { buffer = buf, nowait = true, silent = true, desc = 'Close viewer' })
  vim.keymap.set(
    'n',
    'y',
    copy_to_clipboard,
    { buffer = buf, nowait = true, silent = true, desc = 'Copy messages to clipboard' }
  )
  vim.keymap.set('n', 'r', refresh, { buffer = buf, nowait = true, silent = true, desc = 'Refresh messages' })
  vim.keymap.set('n', 'e', function()
    state.filter = 'error'
    apply_filter()
  end, { buffer = buf, nowait = true, silent = true, desc = 'Filter errors' })
  vim.keymap.set('n', 'w', function()
    state.filter = 'warn'
    apply_filter()
  end, { buffer = buf, nowait = true, silent = true, desc = 'Filter warnings' })
  vim.keymap.set('n', 'a', function()
    state.filter = nil
    apply_filter()
  end, { buffer = buf, nowait = true, silent = true, desc = 'Clear filter' })
  vim.keymap.set('n', 's', save_to_file, { buffer = buf, nowait = true, silent = true, desc = 'Save messages to file' })
end

---Open the interactive messages viewer.
function M.open()
  state.lines = get_messages()
  state.filter = nil
  apply_filter()
  create_window()
end

return M
