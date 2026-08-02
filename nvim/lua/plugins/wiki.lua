return {
  {
    dir = '~/jhconfig/nvim/lua/packages/wiki',
    name = 'wiki',
    event = 'VeryLazy',
    config = function()
      -- Nothing to setup; used on-demand via require('packages.wiki')
    end,
  },
}
