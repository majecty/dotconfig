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

      -- Create new terminal with auto-incrementing id using C-~
      local toggleterm = require('toggleterm')

      vim.keymap.set('n', '<C-~>', function()
        toggleterm.toggle()
      end, { noremap = true, silent = true, desc = 'Add new terminal' })

      vim.keymap.set('i', '<C-~>', function()
        toggleterm.toggle()
      end, { noremap = true, silent = true, desc = 'Add new terminal' })

      vim.keymap.set('t', '<C-~>', function()
        toggleterm.toggle()
      end, { noremap = true, silent = true, desc = 'Add new terminal' })
    end,
  },
}
