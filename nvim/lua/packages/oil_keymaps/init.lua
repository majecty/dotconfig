local M = {}

function M.show_path()
  local oil = require('oil')
  local dir = oil.get_current_dir()
  if dir then
    vim.notify('Oil path: ' .. dir, vim.log.levels.INFO)
  else
    vim.notify('Not in oil.nvim buffer', vim.log.levels.WARN)
  end
end

function M.open_parent()
  vim.cmd('Oil')
end

function M.setup()
  -- Functions are now available for whichkey to call
end

return M
