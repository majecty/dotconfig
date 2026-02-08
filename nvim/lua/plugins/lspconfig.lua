return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      
      -- Enable LSP info logging
      vim.lsp.set_log_level('info')
      
      -- TypeScript Language Server
      lspconfig.tsserver.setup({
        on_attach = function(client, bufnr)
          vim.notify('TypeScript LSP attached to buffer ' .. bufnr, vim.log.levels.INFO)
        end,
        on_error = function(code, err)
          vim.notify('TypeScript LSP error: ' .. tostring(code) .. ' - ' .. tostring(err), vim.log.levels.ERROR)
        end,
        cmd = { '/home/juhyung/.local/share/fnm/node-versions/v24.11.1/installation/bin/typescript-language-server', '--stdio' },
      })
    end,
  },
}
