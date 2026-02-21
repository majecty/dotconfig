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
function M.open_buffer_in_window(buf)
  vim.notify("DEBUG: Opening buffer " .. buf .. " in window", vim.log.levels.INFO)
  
  -- Check if buffer is already displayed
  local existing_win = find_window_for_buffer(buf)
  vim.notify("DEBUG: Existing window: " .. tostring(existing_win), vim.log.levels.INFO)
  
  if existing_win then
    -- Focus existing window
    vim.notify("DEBUG: Focusing existing window", vim.log.levels.INFO)
    vim.api.nvim_set_current_win(existing_win)
  else
    -- Open in new split
    vim.notify("DEBUG: Creating new vsplit", vim.log.levels.INFO)
    vim.cmd('vsplit')
    local win = vim.api.nvim_get_current_win()
    vim.notify("DEBUG: New window: " .. win, vim.log.levels.INFO)
    vim.api.nvim_win_set_buf(win, buf)
    vim.notify("DEBUG: Buffer set to window", vim.log.levels.INFO)
    
    -- Set window options
    vim.wo[win].wrap = false
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
  end
end

---Open output buffer for current file
function M.open_output_buffer()
  local filepath = vim.fn.expand('%:p')
  local buf_name = "Output: " .. vim.fn.fnamemodify(filepath, ':t')
  vim.notify("DEBUG: Looking for buffer: " .. buf_name, vim.log.levels.INFO)
  
  local buf = find_buffer_by_name(buf_name)
  vim.notify("DEBUG: Found buffer: " .. tostring(buf), vim.log.levels.INFO)
  
  if buf then
    M.open_buffer_in_window(buf)
  else
    vim.notify("No output buffer found for current file", vim.log.levels.WARN)
  end
end

---Capture print output to a buffer
---@param fn function function to execute
---@param title string|nil buffer title
---@return BufferHandle buffer number of the output buffer
function M.capture(fn, title)
  title = title or "Print Output"
  vim.notify("DEBUG: Capturing with title: " .. title, vim.log.levels.INFO)
  
  -- Try to find existing buffer
  local buf = find_buffer_by_name(title)
  local is_new = false
  
  if not buf then
    vim.notify("DEBUG: Creating new buffer", vim.log.levels.INFO)
    -- Create new buffer
    buf = vim.api.nvim_create_buf(true, true)
    is_new = true
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'hide'
    vim.bo[buf].swapfile = false
    vim.api.nvim_buf_set_name(buf, title)
    vim.notify("DEBUG: Buffer created: " .. buf, vim.log.levels.INFO)
  else
    vim.notify("DEBUG: Using existing buffer: " .. buf, vim.log.levels.INFO)
  end
  
  -- Clear existing content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  vim.notify("DEBUG: Buffer cleared", vim.log.levels.INFO)
  
  -- Collect print output
  local original_print = print
  local output = {}
  
  -- Override print
  _G.print = function(...)
    local args = {...}
    local line = table.concat(vim.tbl_map(tostring, args), "\t"):gsub("\n", "\\n")
    vim.notify("DEBUG: Captured print: " .. line, vim.log.levels.INFO)
    table.insert(output, line)
    -- original_print(...)
  end
  
  -- Execute function
  vim.notify("DEBUG: Executing function", vim.log.levels.INFO)
  local success, err = pcall(fn)
  vim.notify("DEBUG: Function executed, success: " .. tostring(success), vim.log.levels.INFO)
  
  -- Restore print
  _G.print = original_print
  
  -- Fill buffer with output
  vim.notify("DEBUG: Output lines: " .. #output, vim.log.levels.INFO)
  if #output > 0 then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"(no output)"})
  end
  vim.notify("DEBUG: Buffer filled with content", vim.log.levels.INFO)
  
  if not success then
    vim.notify("Error: " .. tostring(err), vim.log.levels.ERROR)
  end
  
  return buf
end

---Execute Lua file and capture output to buffer
---@param filepath string|nil path to Lua file (nil for current buffer)
function M.luafile_buffer(filepath)
  filepath = filepath or vim.fn.expand('%:p')
  vim.notify("DEBUG: luafile_buffer for: " .. filepath, vim.log.levels.INFO)
  
  local buf = M.capture(function()
    dofile(filepath)
  end, "Output: " .. vim.fn.fnamemodify(filepath, ':t'))
  
  vim.notify("DEBUG: Capture returned buffer: " .. tostring(buf), vim.log.levels.INFO)
  
  -- Open the buffer
  if buf then
    vim.notify("DEBUG: Opening buffer", vim.log.levels.INFO)
    M.open_buffer_in_window(buf)
  else
    vim.notify("DEBUG: No buffer returned!", vim.log.levels.ERROR)
  end
end

return M
