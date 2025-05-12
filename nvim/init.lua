-- Window navigation mappings
-- Reload Neovim config
vim.keymap.set('n', '<C-r>', function()
  vim.cmd('source ' .. vim.fn.expand('~/.config/nvim/init.lua'))
end, { desc = 'Reload Neovim config' })

vim.keymap.set('n', '<leader>e', function()
  vim.cmd('edit ' .. vim.fn.expand('~/.config/nvim/init.lua'))
end, { desc = 'Edit Neovim config' })

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable smart case search
vim.opt.ignorecase = true
vim.opt.smartcase = true

if vim.g.vscode then
    vim.opt.clipboard = "unnamedplus" 
else
  vim.keymap.set('n', '<C-h>', '<C-w>h')
  vim.keymap.set('n', '<C-j>', '<C-w>j')
  vim.keymap.set('n', '<C-k>', '<C-w>k')
  vim.keymap.set('n', '<C-l>', '<C-w>l')
end
require("config.lazy")

vim.api.nvim_echo({{"[nvim/init.lua] loaded", "None"}}, false, {})
