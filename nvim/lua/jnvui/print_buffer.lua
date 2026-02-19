-- jnvui print_buffer.lua
-- Capture print output to a buffer

local M = {}

---Capture print output to a buffer
---@param fn function function to execute
---@param title string|nil buffer title
function M.capture(fn, title)
  title = title or "Print Output"
  
  -- Create new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  vim.api.nvim_buf_set_name(buf, title)
  
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
  
  -- Open buffer in split
  vim.api.nvim_command('vsplit')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  
  -- Set window options
  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_option(win, 'number', false)
  vim.api.nvim_win_set_option(win, 'relativenumber', false)
  
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
