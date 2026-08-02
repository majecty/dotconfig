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

        -- Enable inlay hints if supported
        if client.supports_method('textDocument/inlayHint') then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Keymap to toggle inlay hints
        vim.keymap.set('n', '<leader>ih', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end, { noremap = true, silent = true, buffer = bufnr, desc = 'Toggle inlay hints' })
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

      -- Configure Rust Analyzer for general Rust projects
      vim.lsp.config('rust_analyzer', {
        cmd = { get_mason_bin('rust-analyzer') },
        filetypes = { 'rust' },
        root_dir = function(bufnr, callback)
          local root = vim.fs.root(bufnr, { 'Cargo.toml' })
          -- Exclude rust-lang/rust repository which has x.py
          if root and vim.uv.fs_stat(root .. '/x.py') == nil then
            callback(root)
          end
        end,
        on_attach = on_attach,
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            },
          },
        },
      })

      -- Enable general rust analyzer
      vim.lsp.enable('rust_analyzer')

      -- Configure Rust Analyzer for rust-lang/rust compiler development
      vim.lsp.config('rust_analyzer_rustc', {
        cmd = { get_mason_bin('rust-analyzer') },
        filetypes = { 'rust' },
        root_dir = function(bufnr, callback)
          local root = vim.fs.root(bufnr, { 'x.py' })
          if root then
            callback(root)
          end
        end,
        on_attach = on_attach,
        settings = {
          ['rust-analyzer'] = {
            linkedProjects = {
              'Cargo.toml',
              'compiler/rustc_codegen_cranelift/Cargo.toml',
              'compiler/rustc_codegen_gcc/Cargo.toml',
              'library/Cargo.toml',
              'src/bootstrap/Cargo.toml',
              'src/tools/rust-analyzer/Cargo.toml',
            },
            check = {
              invocationStrategy = 'once',
              overrideCommand = {
                'python3',
                'x.py',
                'check',
                '--json-output',
                '--build-dir',
                'build-rust-analyzer',
              },
            },
            rustfmt = {
              overrideCommand = {
                '${workspaceFolder}/build/host/rustfmt/bin/rustfmt',
                '--edition=2024',
              },
            },
            procMacro = {
              server = '${workspaceFolder}/build/host/stage0/libexec/rust-analyzer-proc-macro-srv',
              enable = true,
            },
            rustc = {
              source = './Cargo.toml',
            },
            cargo = {
              sysrootSrc = './library',
              extraEnv = {
                RUSTC_BOOTSTRAP = '1',
              },
              buildScripts = {
                enable = true,
                invocationStrategy = 'once',
                overrideCommand = {
                  'python3',
                  'x.py',
                  'check',
                  '--json-output',
                  '--compile-time-deps',
                  '--build-dir',
                  'build-rust-analyzer',
                },
              },
            },
            server = {
              extraEnv = {
                RUSTC = '${workspaceFolder}/build/host/stage0/bin/rustc',
                CARGO = '${workspaceFolder}/build/host/stage0/bin/cargo',
              },
            },
          },
        },
      })

      -- Enable rust-lang/rust specific rust analyzer
      vim.lsp.enable('rust_analyzer_rustc')

      -- Map rust-related file extensions to rust filetype
      vim.filetype.add({
        extension = {
          fixed = 'rust',
          pp = 'rust',
          mir = 'rust',
        },
      })
    end,
  },
}
