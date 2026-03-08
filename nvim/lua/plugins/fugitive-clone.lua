return {
  dir = "~/jhconfig/nvim/lua/fugitive-clone",
  name = "fugitive-clone",
  event = "VeryLazy",
  config = function (_, opts)
    vim.keymap.set(
      "n",
      "<leader>gcr",
      function()
        for key, _ in pairs(package.loaded) do
          if vim.startswith(key, "fugitive-clone") then
            package.loaded[key] = nil
          end
        end
        require("fugitive-clone.init").setup(opts)
      end,
      { noremap = true, silent = true, desc = "reload futigive clone plugin" });
    vim.keymap.set(
      "n",
      "<leader>gcs",
      function()
        require("fugitive-clone.init").setup(opts)
      end,
      { noremap = true, silent = true, desc = "run futigive clone plugin" });

    vim.api.nvim_create_user_command('JGit', function(opts)
      require("fugitive-clone.init").jgit(opts.args)
    end, {
        nargs = "*",
        complete = function(arglead, cmdline, cursorpos)
          return require("fugitive-clone.init").jgit_complete(arglead, cmdline, cursorpos)
        end,
        desc = "JGit prefix command"
    })
  end
}
