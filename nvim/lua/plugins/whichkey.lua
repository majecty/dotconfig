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
      '<C-;>',
    },
    opts = {},
    config = function(_, opts)
      local wk = require('which-key')
      local save_cmd = require('packages.session_manager.commands.save_cmd')
      local load_picker_cmd = require('packages.session_manager.commands.load_picker_cmd')
      local tmux_attach_cmd = require('packages.session_manager.commands.tmux_attach_cmd')
      local neovide_restart_cmd = require('packages.session_manager.commands.neovide_restart_cmd')
      local oil = require('packages.oil_keymaps')
      local wk_bindings = require('packages.whichkey_bindings')
      local copy_location = require('packages.copy_location')
      local neovide_font = require('packages.neovide_font')
      local scratch = require('packages.scratch')
      wk.setup(opts)

      -- Add keymaps using the new API
      wk.add({
        {
          '<leader>m',
          function()
            vim.cmd('tabnew')
            vim.cmd('messages')
          end,
          desc = 'Open messages in new tab',
        },
        {
          '<leader>?',
          function()
            wk_bindings.find_bindings()
          end,
          desc = 'Find whichkey bindings',
        },
        {
          '<leader>cl',
          function()
            copy_location.copy_location()
          end,
          desc = 'Copy visual block location',
          mode = { 'v' },
        },
        {
          '<leader>o',
          function()
            vim.cmd('e ~/jhconfig/TODO.md')
          end,
          desc = 'Open TODO',
        },
        {
          '<leader>L',
          function()
            local log_dir = vim.fn.stdpath('log')
            vim.cmd('e ' .. log_dir .. '/session_manager.log')
          end,
          desc = 'Open session_manager log',
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
            save_cmd.save_session_cmd()
          end,
          desc = 'Save session',
        },
        {
          '<leader>sl',
          function()
            load_picker_cmd.load_session_picker_cmd()
          end,
          desc = 'Load session',
        },
        {
          '<leader>st',
          function()
            tmux_attach_cmd.tmux_attach_cmd()
          end,
          desc = 'Tmux attach/create session',
        },
        {
          '<leader>sr',
          function()
            neovide_restart_cmd.neovide_restart_cmd()
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
          '<leader>ld',
          function()
            vim.lsp.buf.definition()
          end,
          desc = 'Go to definition',
        },
        {
          '<leader>lD',
          function()
            require('fzf-lua').diagnostics_document()
          end,
          desc = 'Show diagnostics',
        },
        {
          '<leader>lr',
          function()
            vim.lsp.buf.rename()
          end,
          desc = 'Rename symbol',
        },
        {
          '<leader>lf',
          function()
            vim.lsp.buf.references()
          end,
          desc = 'Find references',
        },
        { '<leader>t', group = '+tab' },
        {
          '<leader>tn',
          function()
            vim.cmd('tabnew')
          end,
          desc = 'Create new tab',
        },
        { '<leader>w', group = '+window' },
        {
          '<leader>w=',
          function()
            vim.cmd('wincmd =')
          end,
          desc = 'Equalize window sizes',
        },
        { '<leader>c', group = '+copilot' },
        {
          '<leader>cs',
          function()
            vim.cmd('Copilot status')
          end,
          desc = 'Copilot status',
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
          '<leader>fh',
          function()
            require('fzf-lua').help_tags()
          end,
          desc = 'Find help tags',
        },
        {
          '<leader>fi',
          function()
            require('fzf-lua').builtin()
          end,
          desc = 'FZF-lua builtin',
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
        {
          '<C-+>',
          function()
            neovide_font.increase_font()
          end,
          desc = 'Increase font size',
        },
        {
          '<C-=>',
          function()
            neovide_font.increase_font()
          end,
          desc = 'Increase font size',
        },
        {
          '<C-->',
          function()
            neovide_font.decrease_font()
          end,
          desc = 'Decrease font size',
        },
        {
          '<C-;>',
          function()
            scratch.toggle_scratch()
          end,
          desc = 'Toggle scratch buffer / Send to terminal',
        },
        {
          '<C-;>',
          function()
            scratch.toggle_scratch()
          end,
          desc = 'Toggle scratch buffer / Send to terminal',
          mode = { 'i' },
        },
        {
          '<C-;>',
          function()
            scratch.toggle_scratch()
          end,
          desc = 'Toggle scratch buffer / Send to terminal',
          mode = { 't' },
        },
      })
    end,
  },
}
