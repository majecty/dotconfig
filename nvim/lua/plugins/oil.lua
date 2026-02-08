return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function(_, opts)
      require('oil').setup(opts)
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      
      -- Function to change oil sort method
      _G.oil_change_sort = function()
        local sort_methods = {
          'basename',
          'modification_time',
          'type',
        }
        require('fzf-lua').fzf_exec(sort_methods, {
          prompt = 'Oil sort method> ',
          actions = {
            default = function(selected)
              local method = selected[1]
              require('oil').set_sort(method)
              vim.notify('Oil sort changed to: ' .. method, vim.log.levels.INFO)
            end,
          },
        })
      end
    end,
  },
}
