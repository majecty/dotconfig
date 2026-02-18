return {
  {
    dir = '~/jhconfig/nvim/lua/packages/notify_buffer',
    name = 'notify-buffer',
    event = 'VeryLazy',
    config = function()
      require('packages.notify_buffer').setup()
    end,
  },
}
