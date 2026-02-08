return {
  {
    dir = '~/jhconfig/nvim/lua/packages/session_manager',
    name = 'session-manager',
    event = 'VimEnter',
    config = function()
      require('packages.session_manager')
    end,
  },
}
