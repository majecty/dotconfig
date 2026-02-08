return {
  {
    'ibhagwan/fzf-lua',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf = require('fzf-lua')

      -- Set fzf-lua as default UI for vim.ui.select
      fzf.setup({
        ui_select = {
          -- Use fzf-lua for all vim.ui.select calls
          enabled = true,
          -- Optional: customize the fzf window
          winopts = {
            height = 0.4,
            width = 0.7,
            preview = {
              hidden = 'hidden',
            },
          },
        },
      })

      -- Register keymaps with which-key
      require('which-key').add({
        { '<leader>f', group = '+file' },
        {
          '<leader>ff',
          function()
            fzf.files()
          end,
          desc = 'Find files',
        },
        {
          '<leader>fb',
          function()
            fzf.buffers()
          end,
          desc = 'Find buffers',
        },
      })
    end,
  },
}
