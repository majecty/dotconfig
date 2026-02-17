return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Enable LSP info logging
      vim.lsp.set_log_level('info')

      -- Setup omnifunc for built-in completion
      vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- On attach handler for LSP
      local on_attach = function(client, bufnr)
        -- Set omnifunc when LSP attaches
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
      end

      -- Get mason binary path helper
      local get_mason_bin = function(binary)
        return vim.fn.stdpath('data') .. '/mason/bin/' .. binary
      end

      -- Configure Lua Language Server
      vim.lsp.config('lua_ls', {
        cmd = { get_mason_bin('lua-language-server') },
        filetypes = { 'lua' },
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim', 'require' },
            },
            workspace = {
              library = {
                vim.fn.expand('$VIMRUNTIME/lua'),
                vim.fn.expand('$VIMRUNTIME/lua/vim'),
                vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Enable lua language server
      vim.lsp.enable('lua_ls')

      -- Configure TypeScript Language Server using vim.lsp.config
      vim.lsp.config('ts_ls', {
        cmd = {
          '/home/juhyung/.local/share/fnm/node-versions/v24.11.1/installation/bin/typescript-language-server',
          '--stdio',
        },
        filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact' },
        on_attach = on_attach,
        init_options = {
          preferences = {
            quotePreference = 'single',
            importModuleSpecifierPreference = 'relative',
            importModuleSpecifierEnding = 'auto',
            allowTextChangesInNewFiles = true,
            allowRenameDefaultExport = true,
          },
        },
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
        on_attach = on_attach,
      })

      -- Enable tailwind language server
      vim.lsp.enable('tailwindcss')
    end,
  },
}
