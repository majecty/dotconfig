return {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('nvim-tree').setup({
      view = {
        width = 30,
        side = 'left',
      },
      git = {
        enable = false,
      },
      renderer = {
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
    })

    -- Auto preview on cursor move
    local api = require('nvim-tree.api')
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = vim.api.nvim_create_augroup('NvimTreePreview', { clear = true }),
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo.filetype == 'NvimTree' then
          local node = api.tree.get_node_under_cursor()
          if node and node.type == 'file' then
            vim.cmd('pedit ' .. node.absolute_path)
            vim.cmd('wincmd P')
            vim.cmd('wincmd L')
            vim.cmd('wincmd p')
          end
        end
      end,
    })

    -- Custom keybinding to open directory in oil.nvim
    vim.keymap.set('n', 'o', function()
      local node = api.tree.get_node_under_cursor()
      if node then
        local path = node.absolute_path
        -- If it's a file, open its parent directory
        if node.type == 'file' then
          path = vim.fn.fnamemodify(path, ':h')
        end
        -- Close nvim-tree and open oil
        api.tree.close()
        vim.cmd('Oil ' .. path)
      end
    end, { buffer = true, noremap = true, silent = true })
  end,
}
