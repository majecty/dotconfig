return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>w",
        function()
          local wk = require("which-key")
          wk.show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
      {
        "<leader>jho",
        function()
          require("jhui.main").open()
        end,
        desc = "Open the jhui buffer",
      },
      {
        "<leader>jhr",
        function()
          package.loaded['jhui.main'] = nil
          require('jhui.main')
          vim.notify("jhui plugin reloaded", vim.log.levels.INFO)
        end,
        desc = "Reload the jhui plugin",
      },
      {
        "<leader>e",
        function()
          require("nvim-tree.api").tree.toggle()
        end,
        desc = "Toggle file tree explorer",
      },
    },
  }
}
