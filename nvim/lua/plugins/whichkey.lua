return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)

      -- Register keymaps
      wk.register({
        ['<leader>'] = {
          w = {
            function()
              wk.show({ global = false })
            end,
            'Buffer Local Keymaps',
          },
          jh = {
            o = {
              function()
                require('jhui.main').open()
              end,
              'Open jhui buffer',
            },
            r = {
              function()
                package.loaded['jhui.main'] = nil
                require('jhui.main')
                vim.notify('jhui plugin reloaded', vim.log.levels.INFO)
              end,
              'Reload jhui plugin',
            },
          },
          e = {
            function()
              require('nvim-tree.api').tree.toggle()
            end,
            'Toggle file tree',
          },
          s = {
            s = {
              function()
                _G.nvim_session.save()
              end,
              'Save session',
            },
            l = {
              function()
                _G.nvim_session.load_picker()
              end,
              'Load session',
            },
            r = {
              function()
                local cwd = vim.fn.getcwd()
                _G.nvim_session.save()
                vim.cmd('sleep 100m')
                os.execute("cd '" .. cwd .. "' && neovide &")
                vim.cmd('qa!')
              end,
              'Reload with GUI',
            },
          },
          E = {
            function()
              vim.cmd('e')
            end,
            'Open file',
          },
          w = {
            w = {
              function()
                vim.cmd('wincmd =')
              end,
              'Equalize splits',
            },
          },
          f = {
            f = {
              function()
                require('fzf-lua').files()
              end,
              'Find files',
            },
          },
        },
        ['<C-h>'] = {
          function()
            vim.cmd('wincmd h')
          end,
          'Move left',
        },
        ['<C-j>'] = {
          function()
            vim.cmd('wincmd j')
          end,
          'Move down',
        },
        ['<C-k>'] = {
          function()
            vim.cmd('wincmd k')
          end,
          'Move up',
        },
        ['<C-l>'] = {
          function()
            vim.cmd('wincmd l')
          end,
          'Move right',
        },
      })
    end,
  },
}
