-- Copy visual block location to clipboard
local M = {}

function M.copy_location()
  local buf = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(buf)

  -- Get the start and end positions of visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  -- Format the location string
  local location = string.format('%s:%d:%d-%d:%d', filename, start_line, start_col, end_line, end_col)

  -- Copy to clipboard
  vim.fn.setreg('+', location)
  vim.notify('Copied: ' .. location, vim.log.levels.INFO)
end

return M
