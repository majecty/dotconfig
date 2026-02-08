return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    lazy = false,
    config = function(_, opts)
      require('oil').setup(opts)
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      
      -- Keymap to show current oil.nvim path
      vim.keymap.set('n', 'gp', function()
        local oil = require('oil')
        local dir = oil.get_current_dir()
        if dir then
          vim.notify('Oil path: ' .. dir, vim.log.levels.INFO)
        else
          vim.notify('Not in oil.nvim buffer', vim.log.levels.WARN)
        end
      end, { buffer = true, desc = 'Show oil.nvim path' })
    end,
  },
}
