return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('toggleterm').setup({
        size = 20,
        insert_mappings = true,
        terminal_mappings = true,
        open_mapping = [[<C-`>]],
        direction = 'horizontal',
        shade_terminals = false,
      })
    end,
  },
}
