return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        "toggleterm",
        "lazy.nvim",
        -- It can also be a table with trigger words / mods
        -- Only load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      }
    },
  },
}
