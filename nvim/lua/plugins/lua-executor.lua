return {
  {
    dir = '~/jhconfig/nvim/lua/packages/lua-executor',
    name = 'lua-executor',
    event = 'VeryLazy',
    config = function()
      local log = require('plenary.log').new({ plugin = 'lua-executor', level = 'info', use_quickfix = true })

      local executor = require('packages.lua-executor')
      executor.setup()
      log.info('lua-executor plugin loaded and setup completed')
    end,
  },
}
