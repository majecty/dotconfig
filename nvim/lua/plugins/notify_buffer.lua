return {
  {
    dir = '~/jhconfig/nvim/lua/packages/notify_buffer',
    name = 'notify-buffer',
    init = function()
      require('packages.notify_buffer').setup()
    end,
  },
}
