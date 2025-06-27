return {
  {
      'fzf',
      dir = '~/.fzf',
      build = './install --all',
      config = function()
        -- help
        vim.keymap.set('n', '<leader>h', ':Help<CR>', { desc = "Help" })
      end,
},
  {
      'junegunn/fzf.vim',
  },
  { 'tpope/vim-fugitive', },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>w",
        function()
          local wk = require("which-key")
          wk.show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  { 'echasnovski/mini.nvim', version = false },
}
