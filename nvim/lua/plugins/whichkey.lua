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
      '-',
      'gp',
    },
    opts = {},
    config = function(_, opts)
      local wk = require('which-key')
      local session = require('packages.session_manager')
      local oil = require('packages.oil_keymaps')
      wk.setup(opts)

      -- Add keymaps using the new API
      wk.add({
        {
          '-',
          function()
            oil.open_parent()
          end,
          desc = 'Open parent directory',
        },
        {
          'gp',
          function()
            oil.show_path()
          end,
          desc = 'Show oil.nvim path',
        },
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
            session.save()
          end,
          desc = 'Save session',
        },
        {
          '<leader>sl',
          function()
            session.load_picker()
          end,
          desc = 'Load session',
        },
        {
          '<leader>st',
          function()
            session.tmux_attach()
          end,
          desc = 'Tmux attach/create session',
        },
        {
          '<leader>sr',
          function()
            session.neovide_restart()
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

