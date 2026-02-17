return {
  {
    dir = '~/jhconfig/nvim/lua/packages/session_manager',
    name = 'session-manager',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('packages.session_manager')
    end,
  },
}
