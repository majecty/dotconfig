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
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'oil',
    callback = function()
      vim.keymap.set('n', '<C-s>', function()
        require('oil').save()
      end, { buffer = true, desc = 'Save oil buffer' })
    end,
  })
end

return M
