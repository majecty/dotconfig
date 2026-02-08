return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = false,
      },
    },
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    lazy = false,
    config = function(_, opts)
      require('oil').setup(opts)
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      
      -- Disable autosave on focus change for oil buffers
      vim.api.nvim_create_autocmd('BufLeave', {
        pattern = 'oil://*',
        callback = function()
          -- Do nothing on focus change
        end,
      })
    end,
  },
}
