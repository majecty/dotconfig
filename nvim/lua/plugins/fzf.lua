return {
  {
    'ibhagwan/fzf-lua',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf = require('fzf-lua')

      ---@class FzfRegisterPicker
      local M = {}

      M.win = nil
      M.buf = nil

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
              return '<C-\\><C-N>pi'
            end, { expr = true, buffer = true })
          end,
        },
      })
    end,
  },
}
