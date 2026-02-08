return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nanozuki/tabby.nvim",
    event = "VimEnter",
    config = function()
      require("tabby.tabline").set(function(line)
        return {
          hl = "TabLine",
          line.wins_in_tab(line.cur_tab),
          line.sep(" ", "TabLine", "TabLine"),
          hl = "TabLineFill",
          line.tabs(),
          hl = "TabLine",
          line.sep(" ", "TabLine", "TabLine"),
          {
            hl = "TabLine",
            " ",
            on_click = function()
              vim.cmd("tabnew")
            end,
          },
        }
      end, {
        buf_name = {
          mode = "unique",
        },
        current_tab_sign = "",
        inactive_tab_sign = "",
      })

      -- H/L keymaps for tab navigation
      vim.keymap.set("n", "H", "<cmd>tabprevious<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "L", "<cmd>tabnext<cr>", { noremap = true, silent = true })
    end,
  },
}
