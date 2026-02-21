return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ['<C-s>'] = false,
        ['S'] = { 'actions.select', opts = { vertical = true } },
        ['V'] = { 'actions.select', opts = { horizontal = true } },
        ['g?'] = false,
        ['?'] = { 'actions.show_help', mode = 'n' },
      },
    },
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
