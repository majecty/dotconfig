return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      
      -- Enable LSP info logging
      vim.lsp.set_log_level('info')
      
      -- Configure TypeScript Language Server (ts_ls)
      lspconfig.ts_ls.setup({
        cmd = { '/home/juhyung/.local/share/fnm/node-versions/v24.11.1/installation/bin/typescript-language-server', '--stdio' },
      })
    end,
  },
}
