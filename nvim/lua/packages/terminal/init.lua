-- Terminal configuration package
local M = {}

function M.setup()
  -- Terminal mode keybindings
  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
  vim.keymap.set('t', '<S-Esc>', '<Esc>', { noremap = true })

  -- Normal mode Alt-Esc: switch to last terminal and send Esc
  vim.keymap.set('n', '<A-Esc>', function()
    vim.cmd('startinsert')
    local chan_id = vim.b.terminal_job_id
    if chan_id then
      vim.api.nvim_chan_send(chan_id, '\27\27') -- send ESC twice
    end
  end, { noremap = true, silent = true })
end

return M
