return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'VeryLazy',
    config = function()
      -- Create new terminal with auto-incrementing id using C-~
      local toggleterm = require('toggleterm')
      local terms = require('toggleterm.terminal')
      local log = require('plenary.log').new({ plugin = 'toggleterm', level = 'info', use_quickfix = true })

      local function add_new_terminal()
        log.info('add_new_terminal: Creating new terminal')
        local all_terms = terms.get_all(true)
        local next_id = 1
        for _, term in pairs(all_terms) do
          if term.id >= next_id then
            next_id = term.id + 1
          end
        end
        log.info(string.format('add_new_terminal: Next ID = %d', next_id))
        toggleterm.toggle(next_id)
      end

      local function cycle_terminal(direction)
        log.info(string.format('cycle_terminal: direction = %s', direction))
        local all_terms = terms.get_all(true)
        if #all_terms == 0 then
          log.warn('cycle_terminal: No terminals available')
          return
        end

        local current_id = terms.get_focused_id()
        log.info(string.format('cycle_terminal: current_id = %s', current_id or 'nil'))
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

        log.info(string.format('cycle_terminal: next_id = %d', next_id or -1))
        if next_id then
          local next_term = terms.get(next_id, true)
          if next_term then
            log.info(string.format('cycle_terminal: Replacing buffer with terminal %d', next_id))
            vim.cmd(string.format('buffer %d', next_term.bufnr))
          else
            log.warn(string.format('cycle_terminal: Terminal %d not found', next_id))
          end
        end
      end

      require('toggleterm').setup({
        size = 20,
        insert_mappings = true,
        terminal_mappings = true,
        open_mapping = [[<C-`>]],
        direction = 'horizontal',
        shade_terminals = false,
        on_open = function(term)
          log.info(string.format('on_open: Terminal %d opened buffer(%d)', term.id, term.bufnr))

          vim.keymap.set({ 'i', 't' }, '<M-Up>', function()
            cycle_terminal('up')
          end, { buffer = term.bufnr, noremap = true, silent = true, desc = 'Cycle to previous terminal' })
          vim.keymap.set({ 'i', 't' }, '<M-Down>', function()
            cycle_terminal('down')
          end, { buffer = term.bufnr, noremap = true, silent = true, desc = 'Cycle to next terminal' })
        end,
      })

      vim.keymap.set('n', '<C-~>', add_new_terminal, { noremap = true, silent = true, desc = 'Add new terminal' })
      vim.keymap.set('i', '<C-~>', add_new_terminal, { noremap = true, silent = true, desc = 'Add new terminal' })
      vim.keymap.set('t', '<C-~>', add_new_terminal, { noremap = true, silent = true, desc = 'Add new terminal' })
      log.info('toggleterm: Setup complete')
    end,
  },
}
