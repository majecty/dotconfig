vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Minimal ctrl-s Save in all modes
vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { silent = true })
vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>gv', { silent = true })

require("config.lazy")
