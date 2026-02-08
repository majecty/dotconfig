return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Enable LSP info logging
      vim.lsp.set_log_level('info')
      
      -- Configure TypeScript Language Server using vim.lsp.config
      vim.lsp.config('ts_ls', {
        cmd = { '/home/juhyung/.local/share/fnm/node-versions/v24.11.1/installation/bin/typescript-language-server', '--stdio' },
        filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
      })
      
      -- Enable typescript language server for appropriate file types
      vim.lsp.enable('ts_ls')
    end,
  },
}
