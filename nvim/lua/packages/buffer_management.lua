--- Buffer Management: Utilities for managing buffers across tabs
--- Provides commands to clean up buffers not visible in any tab

local M = {}

--- Get all buffers shown in at least one tab
local function get_visible_buffers()
  local visible_bufs = {}
  local tabs = vim.api.nvim_list_tabpages()

  for _, tab in ipairs(tabs) do
    local wins = vim.api.nvim_tabpage_list_wins(tab)
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      visible_bufs[buf] = true
    end
  end

  return visible_bufs
end

--- Close all buffers not shown in any tab
function M.close_hidden_buffers()
  local visible_bufs = get_visible_buffers()
  local all_bufs = vim.api.nvim_list_bufs()
  local closed_count = 0

  for _, buf in ipairs(all_bufs) do
    if vim.api.nvim_buf_is_valid(buf) and not visible_bufs[buf] then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local modified = vim.api.nvim_buf_get_option(buf, 'modified')

      -- Skip modified buffers unless forced
      if not modified then
        vim.api.nvim_buf_delete(buf, { force = false })
        closed_count = closed_count + 1
      end
    end
  end

  print(string.format('Closed %d hidden buffers', closed_count))
end

--- Close all buffers not shown in any tab (force, ignore modifications)
function M.close_hidden_buffers_force()
  local visible_bufs = get_visible_buffers()
  local all_bufs = vim.api.nvim_list_bufs()
  local closed_count = 0

  for _, buf in ipairs(all_bufs) do
    if vim.api.nvim_buf_is_valid(buf) and not visible_bufs[buf] then
      vim.api.nvim_buf_delete(buf, { force = true })
      closed_count = closed_count + 1
    end
  end

  print(string.format('Force closed %d hidden buffers', closed_count))
end

--- List all buffers not shown in any tab
function M.list_hidden_buffers()
  local visible_bufs = get_visible_buffers()
  local all_bufs = vim.api.nvim_list_bufs()
  local hidden_bufs = {}

  for _, buf in ipairs(all_bufs) do
    if vim.api.nvim_buf_is_valid(buf) and not visible_bufs[buf] then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local modified = vim.api.nvim_buf_get_option(buf, 'modified')
      table.insert(hidden_bufs, {
        id = buf,
        name = buf_name == '' and '[No Name]' or buf_name,
        modified = modified,
      })
    end
  end

  print('Hidden buffers:')
  for _, buf_info in ipairs(hidden_bufs) do
    local marker = buf_info.modified and '[modified] ' or ''
    print(string.format('  %d: %s%s', buf_info.id, marker, buf_info.name))
  end
end

return M
