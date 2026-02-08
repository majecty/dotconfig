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

      -- Add keymaps using the new API
      wk.add({
        { '<leader>e', group = '+explore' },
        {
          '<leader>ee',
          function()
            require('nvim-tree.api').tree.toggle()
          end,
          desc = 'Toggle file tree',
        },
        { '<leader>s', group = '+session' },
        {
          '<leader>ss',
          function()
            _G.nvim_session.save()
          end,
          desc = 'Save session',
        },
        {
          '<leader>sl',
          function()
            _G.nvim_session.load_picker()
          end,
          desc = 'Load session',
        },
        {
          '<leader>st',
          function()
            _G.session_tmux_attach()
          end,
          desc = 'Tmux attach/create session',
        },
        {
          '<leader>sr',
          function()
            _G.session_neovide_restart()
          end,
          desc = 'Reload with GUI',
        },
        { '<leader>f', group = '+file' },
        {
          '<leader>ff',
          function()
            require('fzf-lua').files()
          end,
          desc = 'Find files',
        },
        {
          '<leader>fb',
          function()
            require('fzf-lua').buffers()
          end,
          desc = 'Find buffers',
        },
        {
          '<C-h>',
          function()
            vim.cmd('wincmd h')
          end,
          desc = 'Move left',
        },
        {
          '<C-j>',
          function()
            vim.cmd('wincmd j')
          end,
          desc = 'Move down',
        },
        {
          '<C-k>',
          function()
            vim.cmd('wincmd k')
          end,
          desc = 'Move up',
        },
        {
          '<C-l>',
          function()
            vim.cmd('wincmd l')
          end,
          desc = 'Move right',
        },
      })
    end,
  },
}

