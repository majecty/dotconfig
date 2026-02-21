local M = {}

M.restart = function()
  local buf = vim.api.nvim_get_current_buf()
  vim.treesitter.stop(buf)
  vim.treesitter.start(buf)
  vim.notify('Treesitter restarted', vim.log.levels.INFO)
end

M.install = function()
  local ft = vim.bo.filetype
  if ft and ft ~= '' then
    vim.cmd('TSInstall! ' .. ft)
    vim.notify('Reinstalling parser for: ' .. ft, vim.log.levels.INFO)
  else
    vim.notify('No filetype detected', vim.log.levels.WARN)
  end
end

return M
