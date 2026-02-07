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
      preview = {
        max_height = 30,
      },
    })

    -- Auto preview on cursor move
    local api = require("nvim-tree.api")
    local function preview_node()
      local node = api.tree.get_node_under_cursor()
      if node and node.type == "file" then
        vim.cmd("pedit " .. node.absolute_path)
      end
    end

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = vim.api.nvim_create_augroup("NvimTreePreview", { clear = true }),
      buffer = 0,
      callback = function()
        if vim.bo.filetype == "NvimTree" then
          preview_node()
        end
      end,
    })
  end,
}
