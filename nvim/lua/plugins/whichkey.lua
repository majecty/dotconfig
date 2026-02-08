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
        {
          '<leader>w',
          function()
            wk.show({ global = false })
          end,
          desc = 'Buffer Local Keymaps',
        },
        { '<leader>j', group = '+jump' },
        {
          '<leader>jo',
          function()
            require('jhui.main').open()
          end,
          desc = 'Open jhui buffer',
        },
        {
          '<leader>jr',
          function()
            package.loaded['jhui.main'] = nil
            require('jhui.main')
            vim.notify('jhui plugin reloaded', vim.log.levels.INFO)
          end,
          desc = 'Reload jhui plugin',
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
             local project_info = _G.nvim_session.get_project_info()
             local session_name = project_info.name
             
             -- Create tmux session if it doesn't exist
             local cmd = "tmux has-session -t " .. session_name .. " 2>/dev/null || tmux new-session -d -s " .. session_name .. " -c " .. project_info.path
             os.execute(cmd)
             
             -- Open terminal at bottom
             vim.cmd('split | terminal tmux attach-session -t ' .. session_name)
             vim.cmd('resize 15')
           end,
           desc = 'Tmux attach/create session',
         },
         {
           '<leader>sr',
           function()
             local cwd = vim.fn.getcwd()
             _G.nvim_session.save()
             vim.cmd('sleep 100m')
             local cmd = "cd '" .. cwd:gsub("'", "'\\''") .. "' && /home/juhyung/.cargo/bin/neovide > /dev/null 2>&1 &"
             vim.notify('Starting Neovide: ' .. cmd, vim.log.levels.INFO)
             os.execute(cmd)
             vim.cmd('qa!')
           end,
           desc = 'Reload with GUI',
         },
        {
          '<leader>E',
          function()
            vim.cmd('e')
          end,
          desc = 'Open file',
        },
        { '<leader>w', group = '+window' },
        {
          '<leader>ww',
          function()
            vim.cmd('wincmd =')
          end,
          desc = 'Equalize splits',
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
           '<leader>fs',
           function()
             require('packages.oil_utils').change_sort()
           end,
           desc = 'Change oil sort',
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
