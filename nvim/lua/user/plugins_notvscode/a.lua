return {
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      enable = true
    }
  },
  { 'tpope/vim-fugitive', event = "VeryLazy", },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        -- "<leader>w",
        function()
          local wk = require("which-key")
          wk.show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  { 'echasnovski/mini.nvim', version = false, event = "VeryLazy", },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function ()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "go", "gomod", "gowork", "gosum" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function() end
  },
  {
    "echasnovski/mini.icons",
    event = "VeryLazy",
    opts = {
      file = {
        [".go-version"] = { glyph = "\u{e627}", hl = "MiniIconsBlue" },
      },
      filetype = {
        gotmpl = { glyph = "", hl = "MiniIconsGrey" },
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require('lualine').setup({})
    end,
    event = "VeryLazy",
  },
  -- lazy.nvim
  {
    'stevearc/overseer.nvim',
    event = "VeryLazy",
    opts = {},
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup()
      vim.diagnostic.config({ virtual_text = false })
    end
  }, 
}
