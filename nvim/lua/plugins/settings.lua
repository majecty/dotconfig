return {
  {
    dir = '~/jhconfig/nvim/lua/packages/settings',
    name = 'nvim-settings',
    priority = 1000,
    config = function()
      require('packages.settings').setup()
    end,
  },
}
