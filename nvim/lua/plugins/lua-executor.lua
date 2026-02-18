return {
  {
    dir = '~/jhconfig/nvim/lua/packages/lua-executor',
    name = 'lua-executor',
    event = 'VeryLazy',
    config = function()
      local executor = require('packages.lua-executor')
      executor.setup()
      vim.notify('lua-executor loaded', vim.log.levels.INFO)
    end,
  },
}
