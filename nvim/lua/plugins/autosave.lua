return {
  'vim-scripts/vim-auto-save',
  lazy = false,
  config = function()
    vim.g.auto_save = 1
    vim.g.auto_save_events = { 'InsertLeave', 'FocusLost' }
  end,
}
