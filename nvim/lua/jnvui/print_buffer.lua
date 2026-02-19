-- jnvui print_buffer.lua
-- Capture print output to a buffer

local M = {}

---Find existing buffer by name
---@param name string buffer name to find
---@return number|nil buffer number or nil if not found
local function find_buffer_by_name(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name:match(name .. "$") then
        return buf
      end
    end
  end
  return nil
end

---Find window displaying buffer
---@param buf number buffer number
---@return number|nil window id or nil if not found
local function find_window_for_buffer(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
      return win
    end
  end
  return nil
end

---Open buffer in a window
---@param buf number buffer number
local function open_buffer_in_window(buf)
  -- Check if buffer is already displayed
  local existing_win = find_window_for_buffer(buf)
  if existing_win then
    -- Focus existing window
    vim.api.nvim_set_current_win(existing_win)
  else
    -- Open in new split
    vim.api.nvim_command('vsplit')
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    
    -- Set window options
    vim.api.nvim_win_set_option(win, 'wrap', false)
    vim.api.nvim_win_set_option(win, 'number', false)
    vim.api.nvim_win_set_option(win, 'relativenumber', false)
  end
end

---Capture print output to a buffer
---@param fn function function to execute
---@param title string|nil buffer title
function M.capture(fn, title)
  title = title or "Print Output"
  
  -- Try to find existing buffer
  local buf = find_buffer_by_name(title)
  local is_new = false
  
  if not buf then
    -- Create new buffer
    buf = vim.api.nvim_create_buf(false, true)
    is_new = true
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_name(buf, title)
  end
  
  -- Clear existing content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  
  -- Collect print output
  local original_print = print
  local output = {}
  
  -- Override print
  _G.print = function(...)
    local args = {...}
    local line = table.concat(vim.tbl_map(tostring, args), "\t")
    table.insert(output, line)
    original_print(...)
  end
  
  -- Execute function
  local success, err = pcall(fn)
  
  -- Restore print
  _G.print = original_print
  
  -- Fill buffer with output
  if #output > 0 then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"(no output)"})
  end
  
  -- Always open/show buffer
  open_buffer_in_window(buf)
  
  if not success then
    vim.notify("Error: " .. tostring(err), vim.log.levels.ERROR)
  end
end

---Execute Lua file and capture output to buffer
---@param filepath string|nil path to Lua file (nil for current buffer)
function M.luafile_buffer(filepath)
  filepath = filepath or vim.fn.expand('%:p')
  
  M.capture(function()
    dofile(filepath)
  end, "Output: " .. vim.fn.fnamemodify(filepath, ':t'))
end

return M
