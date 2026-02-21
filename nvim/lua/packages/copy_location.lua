---@class CopyLocation
local M = {}

---Copy file location to clipboard
---In normal mode: copies current cursor position
---In visual mode: copies selection range
---@return nil
function M.copy_location()
  local buf = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(buf)

  local mode = vim.fn.mode()
  local location

  if mode == 'v' or mode == 'V' or mode == '\22' then
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line = start_pos[2]
    local start_col = start_pos[3]
    local end_line = end_pos[2]
    local end_col = end_pos[3]
    location = string.format('%s:%d:%d-%d:%d', filename, start_line, start_col, end_line, end_col)
  else
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1]
    local col = cursor[2] + 1
    location = string.format('%s:%d:%d', filename, line, col)
  end

  vim.fn.setreg('+', location)
  vim.notify('Copied: ' .. location, vim.log.levels.INFO)
end

return M
