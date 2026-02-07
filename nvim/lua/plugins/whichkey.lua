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
      {
        "<leader>ss",
        function()
          _G.nvim_session.save()
        end,
        desc = "Save session (auto project name)",
      },
       {
         "<leader>sl",
         function()
           _G.nvim_session.load_picker()
         end,
         desc = "Load session (pick from list)",
       },
         {
           "<leader>sr",
           function()
             local cwd = vim.fn.getcwd()
             _G.nvim_session.save()
             -- Small delay to ensure session is written
             vim.cmd("sleep 100m")
             os.execute("cd '" .. cwd .. "' && neovide &")
             vim.cmd("qa!")
           end,
           desc = "Save session and reopen with GUI",
         },
          {
            "<leader>E",
            function()
              vim.cmd("e")
            end,
            desc = "Open file for editing",
          },
          {
            "<C-h>",
            function()
              vim.cmd("wincmd h")
            end,
            desc = "Move to left split",
          },
          {
            "<C-j>",
            function()
              vim.cmd("wincmd j")
            end,
            desc = "Move to down split",
          },
          {
            "<C-k>",
            function()
              vim.cmd("wincmd k")
            end,
            desc = "Move to up split",
          },
           {
             "<C-l>",
             function()
               vim.cmd("wincmd l")
             end,
             desc = "Move to right split",
           },
            {
              "<leader>ww",
              function()
                vim.cmd("wincmd =")
              end,
              desc = "Equalize split sizes",
            },
            {
              "<leader>ff",
              function()
                require("fzf-lua").files()
              end,
              desc = "Find files (fzf)",
            },
    },
  }
}
