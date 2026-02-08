return {
  {
    dir = '~/jhconfig/nvim/lua/packages/terminal',
    name = 'nvim-terminal',
    event = 'TermEnter',
    config = function()
      require('packages.terminal').setup()
    end,
  },
}
