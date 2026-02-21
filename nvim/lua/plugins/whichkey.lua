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
      local playground = require('packages.playground')
      local buffer_mgmt = require('packages.buffer_management')
      local notify_buffer = require('packages.notify_buffer')
      playground.setup()
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
        {
          '<leader>sd',
          function()
            vim.cmd('e ~/.local/share/nvim/sessions')
          end,
          desc = 'Open session dir',
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
          '<C-.>',
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
            require('fzf-lua').lsp_references()
          end,
          desc = 'Find references',
        },
        {
          '<leader>ls',
          function()
            require('fzf-lua').lsp_document_symbols()
          end,
          desc = 'Document symbols',
        },
        { '<leader>t', group = '+tab' },
        {
          '<leader>tn',
          function()
            vim.cmd('tabnew')
          end,
          desc = 'Create new tab',
        },
        {
          '<leader>tt',
          function()
            vim.cmd('tabnew')
            vim.cmd('terminal')
          end,
          desc = 'Open terminal in new tab',
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
        { '<leader>q', group = '+quickfix' },
        {
          '<leader>qo',
          function()
            vim.cmd('copen')
          end,
          desc = 'Open quickfix',
        },
        {
          '<leader>qc',
          function()
            vim.cmd('cclose')
          end,
          desc = 'Close quickfix',
        },
        {
          '<leader>qn',
          function()
            vim.cmd('cnext')
          end,
          desc = 'Next quickfix item',
        },
        {
          '<leader>qp',
          function()
            vim.cmd('cprev')
          end,
          desc = 'Previous quickfix item',
        },
        {
          '<leader>qf',
          function()
            vim.cmd('cfirst')
          end,
          desc = 'First quickfix item',
        },
        {
          '<leader>ql',
          function()
            vim.cmd('clast')
          end,
          desc = 'Last quickfix item',
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
          '<leader>f?',
          function()
            require('fzf-lua').builtin()
          end,
          desc = 'FZF-lua builtin',
        },
        {
          '<leader>fH',
          function()
            require('fzf-lua').history()
          end,
          desc = 'Find history',
        },
        { '<leader>B', group = '+buffer management' },
        {
          '<leader>bn',
          function()
            notify_buffer.toggle()
          end,
          desc = 'Toggle notify buffer',
        },
        {
          '<leader>bc',
          function()
            notify_buffer.clear()
          end,
          desc = 'Clear notify buffer',
        },
        {
          '<leader>bt',
          function()
            vim.cmd('NotifyTest')
          end,
          desc = 'Test notify',
        },
        {
          '<leader>BC',
          function()
            buffer_mgmt.close_hidden_buffers_force()
          end,
          desc = 'Force close hidden buffers',
        },
        {
          '<leader>Bl',
          function()
            buffer_mgmt.list_hidden_buffers()
          end,
          desc = 'List hidden buffers',
        },
        { '<leader>y', group = '+learn' },
        {
          '<leader>yl',
          function()
            vim.cmd('LuaPlayground')
          end,
          desc = 'Lua code playground',
        },
        { '<leader>j', group = '+jnvui' },
        {
          '<leader>jr',
          function()
            require('jnvui').reload()
          end,
          desc = 'Reload jnvui',
        },
        {
          '<leader>jx',
          function()
            vim.cmd('luafile %')
          end,
          desc = 'Execute current Lua file',
        },
        {
          '<leader>jp',
          function()
            require('jnvui').print_buffer.luafile_buffer()
          end,
          desc = 'Execute Lua file and show output in buffer',
        },
        {
          '<leader>jo',
          function()
            require('jnvui').print_buffer.open_output_buffer()
          end,
          desc = 'Open output buffer for current file',
        },
        { '<leader>yL', group = '+lua (focused)' },
        {
          '<leader>yLs',
          function()
            vim.cmd('SplitLuaPlayground')
          end,
          desc = 'Split Lua playground',
        },
        {
          '<leader>yLl',
          function()
            vim.cmd('LuaExecuteLine')
          end,
          desc = 'Execute line',
        },
        {
          '<leader>yLv',
          function()
            vim.cmd('LuaShowVariables')
          end,
          desc = 'Show variables',
        },
        {
          '<leader>yLb',
          function()
            vim.cmd('BufferLuaPlayground')
          end,
          desc = 'Buffer Lua playground',
        },
        {
          '<leader>yLw',
          function()
            vim.cmd('WindowLuaPlayground')
          end,
          desc = 'Window Lua playground',
        },
        {
          '<leader>yLt',
          function()
            vim.cmd('TabLuaPlayground')
          end,
          desc = 'Tab Lua playground',
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
          '<C-/>',
          function()
            neovide_font.decrease_font()
          end,
          desc = 'Decrease font size',
        },
        {
          '<C-/>',
          function()
            vim.cmd('normal gcc')
          end,
          desc = 'Toggle comment',
          mode = { 'n', 'v' },
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
        {
          '<leader>xe',
          function()
            if vim.bo.filetype == 'markdown' then
              require('packages.edit-code-block').edit_code_block()
            else
              vim.notify('Not a markdown file', vim.log.levels.WARN)
            end
          end,
          desc = 'Edit code block in markdown',
        },
        {
          '<leader>xm',
          function()
            if vim.bo.filetype == 'markdown' then
              require('packages.edit-code-block').extract_all_code_blocks()
            else
              vim.notify('Not a markdown file', vim.log.levels.WARN)
            end
          end,
          desc = 'Extract all code blocks to lua file',
        },
      })
    end,
  },
}
