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

      local function cycle_terminal(direction)
        local all_terms = terms.get_all(true)
        if #all_terms == 0 then
          return
        end

        local current_id = terms.get_focused_id()
        local sorted_ids = {}
        for _, term in pairs(all_terms) do
          table.insert(sorted_ids, term.id)
        end
        table.sort(sorted_ids)

        local next_id
        if not current_id then
          next_id = sorted_ids[1]
        else
          local current_index = nil
          for i, id in ipairs(sorted_ids) do
            if id == current_id then
              current_index = i
              break
            end
          end

          if direction == 'up' then
            next_id = sorted_ids[current_index - 1] or sorted_ids[#sorted_ids]
          else -- down
            next_id = sorted_ids[current_index + 1] or sorted_ids[1]
          end
        end

        if next_id then
          toggleterm.toggle(next_id)
        end
      end

      vim.keymap.set('n', '<C-~>', add_new_terminal, { noremap = true, silent = true, desc = 'Add new terminal' })
      vim.keymap.set('i', '<C-~>', add_new_terminal, { noremap = true, silent = true, desc = 'Add new terminal' })
      vim.keymap.set('t', '<C-~>', add_new_terminal, { noremap = true, silent = true, desc = 'Add new terminal' })

      vim.keymap.set('n', '<M-Up>', function()
        cycle_terminal('up')
      end, { noremap = true, silent = true, desc = 'Cycle to previous terminal' })
      vim.keymap.set('i', '<M-Up>', function()
        cycle_terminal('up')
      end, { noremap = true, silent = true, desc = 'Cycle to previous terminal' })
      vim.keymap.set('t', '<M-Up>', function()
        cycle_terminal('up')
      end, { noremap = true, silent = true, desc = 'Cycle to previous terminal' })

      vim.keymap.set('n', '<M-Down>', function()
        cycle_terminal('down')
      end, { noremap = true, silent = true, desc = 'Cycle to next terminal' })
      vim.keymap.set('i', '<M-Down>', function()
        cycle_terminal('down')
      end, { noremap = true, silent = true, desc = 'Cycle to next terminal' })
      vim.keymap.set('t', '<M-Down>', function()
        cycle_terminal('down')
      end, { noremap = true, silent = true, desc = 'Cycle to next terminal' })
    end,
  },
}
