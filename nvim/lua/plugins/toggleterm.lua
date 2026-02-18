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
      local terms = require('toggleterm.terminal')

      local function add_new_terminal()
        local all_terms = terms.get_all(true)
        local next_id = 1
        for _, term in pairs(all_terms) do
          if term.id >= next_id then
            next_id = term.id + 1
          end
        end
        toggleterm.toggle(next_id)
      end

      vim.keymap.set('n', '<C-~>', add_new_terminal, { noremap = true, silent = true, desc = 'Add new terminal' })
      vim.keymap.set('i', '<C-~>', add_new_terminal, { noremap = true, silent = true, desc = 'Add new terminal' })
      vim.keymap.set('t', '<C-~>', add_new_terminal, { noremap = true, silent = true, desc = 'Add new terminal' })
    end,
  },
}
