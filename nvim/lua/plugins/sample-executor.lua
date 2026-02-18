return {
  {
    dir = '~/jhconfig/nvim/lua/packages/sample-executor',
    name = 'sample-executor',
    event = 'VeryLazy',
    config = function()
      vim.notify('Loading sample-executor (VeryLazy)', vim.log.levels.INFO)
      local sample = require('packages.sample-executor')
      sample.setup()
    end,
  },
}
