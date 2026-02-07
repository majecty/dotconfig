return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
      },
      git = {
        enable = false,
      },
      renderer = {
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
    })

    -- Keybinds
    local api = require("nvim-tree.api")
    vim.keymap.set("n", "<leader>e", api.tree.toggle, { noremap = true, silent = true })
  end,
}
