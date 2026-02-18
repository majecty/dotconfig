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

      -- Create additional terminal with C-@
      local Terminal = require('toggleterm.terminal').Terminal
      local additional_term = Terminal:new({ direction = 'horizontal', size = 20 })

      vim.keymap.set('n', '<C-@>', function()
        additional_term:toggle()
      end, { noremap = true, silent = true })

      vim.keymap.set('i', '<C-@>', function()
        additional_term:toggle()
      end, { noremap = true, silent = true })

      vim.keymap.set('t', '<C-@>', function()
        additional_term:toggle()
      end, { noremap = true, silent = true })
    end,
  },
}
