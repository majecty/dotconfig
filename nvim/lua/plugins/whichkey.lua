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
      local session = require('packages.session_manager')
      local oil = require('packages.oil_keymaps')
      local wk_bindings = require('packages.whichkey_bindings')
      wk.setup(opts)

      -- Add keymaps using the new API
      wk.add({
        {
          '<leader>?',
          function()
            wk_bindings.find_bindings()
          end,
          desc = 'Find whichkey bindings',
        },
        {
          '-',
          function()
            oil.open_parent()
          end,
          desc = 'Open parent directory',
        },
        {
          '<leader>p',
          function()
            oil.show_path()
          end,
          desc = 'Show oil.nvim path',
        },
        {
          '<leader>e',
          function()
            vim.cmd('e')
          end,
          desc = 'Open file dialog',
        },
        {
          '<leader>E',
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
        { '<leader>l', group = '+lsp' },
        {
          '<leader>la',
          function()
            vim.lsp.buf.code_action()
          end,
          desc = 'Code actions',
        },
        {
          '<leader>lr',
          function()
            vim.lsp.buf.rename()
          end,
          desc = 'Rename symbol',
        },
        {
          '<leader>ld',
          function()
            vim.lsp.buf.definition()
          end,
          desc = 'Go to definition',
        },
        {
          '<leader>lf',
          function()
            vim.lsp.buf.references()
          end,
          desc = 'Find references',
        },
        { '<leader>g', group = '+git' },
        {
          '<leader>gg',
          function()
            vim.cmd('Git')
          end,
          desc = 'Open fugitive',
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
          '<leader>fg',
          function()
            require('fzf-lua').live_grep()
          end,
          desc = 'Find text in repo',
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
          mode = { 'n' },
        },
        {
          '<C-k>',
          function()
            vim.cmd('wincmd k')
          end,
          desc = 'Move up',
          mode = { 'n' },
        },
        {
          '<C-l>',
          function()
            vim.cmd('wincmd l')
          end,
          desc = 'Move right',
        },
        {
          '<C-j>',
          'copilot#Accept("\\<CR>")',
          desc = 'Accept copilot suggestion',
          mode = { 'i' },
          expr = true,
          replace_keycodes = false,
        },
        {
          '<C-x><C-o>',
          '<C-x><C-o>',
          desc = 'Trigger LSP completion',
          mode = { 'i' },
        },
      })
    end,
  },
}
