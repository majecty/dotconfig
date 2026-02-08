return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    lazy = false,
    config = function(_, opts)
      require('oil').setup(opts)
    end,
  },
  {
    dir = '~/jhconfig/nvim/lua/packages/oil_keymaps',
    name = 'oil-keymaps',
    event = 'VeryLazy',
    config = function()
      require('packages.oil_keymaps').setup()
    end,
  },
}
