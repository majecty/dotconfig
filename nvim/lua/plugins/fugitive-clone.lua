return {
  dir = "~/jhconfig/nvim/lua/packages/fugitive-clone",
  name = "fugitive-clone",
  event = "VeryLazy",
  config = function (_, opts)
    vim.keymap.set(
      "n",
      "<leader>gcr",
      function()
        -- remove code cache
        package.loaded["packages.fugitive-clone"] = nil
        require("packages.fugitive-clone").setup(opts)
      end,
      { noremap = true, silent = true, desc = "reload futigive clone plugin" });
    vim.keymap.set(
      "n",
      "<leader>gcs",
      function()
        require("packages.fugitive-clone").setup(opts)
      end,
      { noremap = true, silent = true, desc = "run futigive clone plugin" });
  end
}
