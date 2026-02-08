return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Enable LSP info logging
      vim.lsp.set_log_level('info')

      -- Configure TypeScript Language Server using vim.lsp.config
      vim.lsp.config('ts_ls', {
        cmd = {
          '/home/juhyung/.local/share/fnm/node-versions/v24.11.1/installation/bin/typescript-language-server',
          '--stdio',
        },
        filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
      })

      -- Enable typescript language server for appropriate file types
      vim.lsp.enable('ts_ls')

      -- Configure Tailwind CSS Language Server
      vim.lsp.config('tailwindcss', {
        cmd = {
          '/home/juhyung/.local/share/fnm/node-versions/v24.11.1/installation/lib/node_modules/@tailwindcss/language-server/bin/tailwindcss-language-server',
          '--stdio',
        },
        filetypes = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = {
          'tailwind.config.js',
          'tailwind.config.ts',
          'tailwind.config.cjs',
          'tailwind.config.mjs',
          'postcss.config.js',
          'postcss.config.ts',
          'postcss.config.cjs',
          'postcss.config.mjs',
        },
      })

      -- Enable tailwind language server
      vim.lsp.enable('tailwindcss')
    end,
  },
}
