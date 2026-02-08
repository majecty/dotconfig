return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
      '<leader>',
      '<C-h>',
      '<C-j>',
      '<C-k>',
      '<C-l>',
    },
    opts = {},
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
    end,
  },
}

