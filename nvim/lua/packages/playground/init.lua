--- Playground commands initialization

local M = {}

function M.setup()
  local split_playground = require('packages.playground.split_playground')
  local buffer_playground = require('packages.playground.buffer_playground')
  local window_playground = require('packages.playground.window_playground')

  vim.api.nvim_create_user_command('SplitPlayground', function()
    split_playground.start()
  end, { desc = 'Start split/viewport playground' })

  vim.api.nvim_create_user_command('BufferPlayground', function()
    buffer_playground.start()
  end, { desc = 'Start buffer playground' })

  vim.api.nvim_create_user_command('WindowPlayground', function()
    window_playground.start()
  end, { desc = 'Start window/tab playground' })
end

return M
