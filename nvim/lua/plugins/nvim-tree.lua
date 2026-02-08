return {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local api = require('nvim-tree.api')
    
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
      on_attach = function(bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        -- Use 'e' to open in oil.nvim
        vim.keymap.set('n', 'e', function()
          local node = api.tree.get_node_under_cursor()
          if node then
            local path = node.absolute_path
            if node.type == 'file' then
              path = vim.fn.fnamemodify(path, ':h')
            end
            api.tree.close()
            vim.cmd('Oil ' .. path)
          end
        end, opts)
      end,
    })

    -- Auto preview on cursor move
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
  end,
}
