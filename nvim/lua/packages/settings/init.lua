-- Core Neovim settings package
local M = {}

function M.setup()
  -- Leader keys
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Clipboard: sync with system clipboard
  vim.opt.clipboard = 'unnamedplus'

  -- Disable netrw, prefer oil.nvim
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- Auto reload file when changed externally
  vim.opt.autoread = true
  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
    pattern = '*',
    callback = function()
      if vim.fn.getcmdtype() == '' then
        vim.cmd('checktime')
      end
    end,
  })

  -- Smart case: case-insensitive search unless uppercase used
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Indentation: use spaces instead of tabs, 2-space indent
  vim.opt.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2

  -- Minimal ctrl-s Save in all modes
  vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true })
  vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { silent = true })
  vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>gv', { silent = true })

  -- Ensure tab settings are not overridden by other plugins
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = function()
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
    end,
  })
end

return M
