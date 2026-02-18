-- Minimal sample local plugin for VeryLazy demo
local M = {}

function M.setup()
  vim.notify('sample-executor setup called', vim.log.levels.INFO)

  vim.api.nvim_create_user_command('SampleExec', function()
    vim.notify('SampleExec command ran', vim.log.levels.INFO)
  end, { desc = 'Run sample executor' })
end

return M
