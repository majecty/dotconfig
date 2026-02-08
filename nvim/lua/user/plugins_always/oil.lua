return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    opts = {},
    config = function(_, opts)
      require('oil').setup(opts)
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
}
