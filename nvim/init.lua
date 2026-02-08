vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clipboard: sync with system clipboard
vim.opt.clipboard = 'unnamedplus'

-- Disable netrw, prefer oil.nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Minimal ctrl-s Save in all modes
vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { silent = true })
vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>gv', { silent = true })

require("config.lazy")
