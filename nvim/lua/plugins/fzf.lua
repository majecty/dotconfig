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
          enabled = true,
          winopts = {
            height = 0.4,
            width = 0.7,
            preview = {
              hidden = 'hidden',
            },
          },
        },
        winopts = {
          on_create = function()
            vim.keymap.set('t', '<C-r>', function()
              return '<C-\\><C-N>"' .. vim.fn.nr2char(vim.fn.getchar()) .. 'pi'
            end, { expr = true, buffer = true })
          end,
        },
      })
    end,
  },
}
