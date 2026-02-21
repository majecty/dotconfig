return {
  {
    dir = '~/jhconfig/nvim/lua/packages/hydra',
    name = 'hydra',
    event = 'VeryLazy',
  },
  {
    dir = '~/jhconfig/nvim/lua/packages/window_tree',
    name = 'window_tree',
    event = 'VeryLazy',
    config = function()
      require('packages.window_tree').setup()
    end,
  },
}