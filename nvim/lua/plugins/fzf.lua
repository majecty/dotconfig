return {
  {
    'ibhagwan/fzf-lua',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf = require('fzf-lua')

      ---@class FzfRegisterPicker
      local M = {}

      M.win = nil
      M.buf = nil

      M.show = function()
        if M.win and vim.api.nvim_win_is_valid(M.win) then
          return
        end

        local lines = { 'Registers:', '' }
        local regs = {
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          'a',
          'b',
          'c',
          'd',
          'e',
          'f',
          'g',
          'h',
          'i',
          'j',
          'k',
          'l',
          'm',
          'n',
          'o',
          'p',
          'q',
          'r',
          's',
          't',
          'u',
          'v',
          'w',
          'x',
          'y',
          'z',
          '"',
          '+',
          '*',
        }

        for _, reg in ipairs(regs) do
          local content = vim.fn.getreg(reg)
          if content and content ~= '' then
            content = content:gsub('\n', '\\n'):sub(1, 40)
            table.insert(lines, string.format('  "%s: %s', reg, content))
          end
        end

        M.buf = vim.api.nvim_create_buf(false, true)
        assert(M.buf, 'Failed to create buffer')
        assert(vim.api.nvim_buf_is_valid(M.buf), 'Invalid buffer')
        vim.notify('lines: ' .. #lines, vim.log.levels.INFO, { title = 'FzfRegisterPicker', lines = lines })
        vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
        vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = M.buf })

        local width = 50
        local height = math.min(#lines, 15)
        local col = vim.o.columns - width - 2
        local row = vim.o.lines - height - 4

        M.win = vim.api.nvim_open_win(M.buf, false, {
          relative = 'editor',
          row = row,
          col = col,
          width = width,
          height = height,
          style = 'minimal',
          border = 'rounded',
          title = ' Registers ',
          title_pos = 'center',
        })
      end

      M.hide = function()
        if M.win and vim.api.nvim_win_is_valid(M.win) then
          vim.api.nvim_win_close(M.win, true)
          M.win = nil
        end
      end

      fzf.setup({
        ui_select = {
          enabled = true,
          winopts = {
            height = 0.4,
            width = 0.7,
            preview = {
              hidden = 'hidden',
            },
          },
        },
        winopts = {
          on_create = function()
            vim.keymap.set('t', '<C-r>', function()
              M.show()
              local char = vim.fn.nr2char(vim.fn.getchar())
              M.hide()
              return '<C-\\><C-N>"' .. char .. 'pi'
            end, { expr = true, buffer = true })
          end,
        },
      })
    end,
  },
}
