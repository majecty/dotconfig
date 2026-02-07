return {
  {
    'stevearc/oil.nvim',
    opts = {},
    config = function()
      vim.keymap.set('n', '<leader>-', require('oil').open, { desc = 'Oil Directory Browser' })
    end,
  },
}
