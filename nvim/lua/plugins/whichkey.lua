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
    },
  }
}
