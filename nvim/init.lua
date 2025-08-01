-- Window navigation mappings
-- Reload Neovim config
vim.keymap.set('n', '<C-r>', function()
  vim.cmd('source ' .. vim.fn.expand('~/.config/nvim/init.lua'))
end, { desc = 'Reload Neovim config' })

vim.keymap.set('n', '<leader>e', function()
  vim.cmd('edit ' .. vim.fn.expand('~/.config/nvim/init.lua'))
  print("open init.lua")
end, { desc = 'Edit Neovim config' })

vim.keymap.set('n', 'U', function()
  vim.cmd('redo')
  print('redo')
end, { desc = 'Redo' })

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable smart case search
vim.opt.ignorecase = true
vim.opt.smartcase = true

if vim.g.vscode then
    vim.opt.clipboard = "unnamedplus" 
else
  vim.keymap.set('n', '<C-h>', '<C-w>h')
  vim.keymap.set('n', '<C-j>', '<C-w>j')
  vim.keymap.set('n', '<C-k>', '<C-w>k')
  vim.keymap.set('n', '<C-l>', '<C-w>l')
end


if vim.g.neovide then
  -- 저장
  vim.keymap.set('n', '<D-s>', ':w<CR>')
  vim.keymap.set('i', '<D-s>', '<ESC>:w<CR>')
  -- 복사 (비주얼 모드)
  vim.keymap.set('v', '<D-c>', '"+y')
  -- 붙여넣기 (노멀/비주얼/커맨드/인서트 모드)
  vim.keymap.set('n', '<D-v>', '"+p')
  vim.keymap.set('v', '<D-v>', '"+p')
  vim.keymap.set('c', '<D-v>', '<C-R>+')
  vim.keymap.set('i', '<D-v>', '<ESC>"+p')

  vim.opt.expandtab = true      -- Tab을 실제 탭 문자가 아니라 스페이스로 변환
  vim.opt.tabstop = 2          -- 파일 내 탭 문자의 표시 폭을 2로
  vim.opt.softtabstop = 2      -- Insert 모드에서 Tab 키를 누를 때 2칸 스페이스로 동작
  vim.opt.shiftwidth = 2       -- 자동 들여쓰기(`>>`, `<<` 등) 시 2칸 스페이스 사용
  vim.opt.autoindent = true    -- 자동 들여쓰기
  vim.opt.smartindent = true   -- 스마트 들여쓰기(선택)

  vim.cmd("colorscheme unokai")
end


require("config.lazy")

vim.api.nvim_echo({{"[nvim/init.lua] loaded", "None"}}, false, {})

if vim.g.vscode then
else
  -- fzf
  local FzfLua = require('fzf-lua')
  FzfLua.register_ui_select()
  vim.keymap.set('n', '<leader>b', FzfLua.buffers, { desc = 'buffers' })
  vim.keymap.set('n', '<leader>ff', FzfLua.files, { desc = 'open files' })
  vim.keymap.set('n', '<leader>sd', FzfLua.diagnostics_workspace, { desc = 'diagnostics' })
  vim.keymap.set('n', '<leader>sD', FzfLua.diagnostics_document, { desc = 'buffer diagnostics' })
  vim.keymap.set({'n', 'v'}, '<leader>ca', FzfLua.lsp_code_actions, { desc = 'code actions' })
  vim.keymap.set('n', '<leader>h', FzfLua.helptags, { desc = 'helptags' })
  vim.keymap.set('n', '<leader>m', FzfLua.keymaps, { desc = 'keymaps' })
  -- vim.keymap.set('v', '<leader>ca', FzfLua.lsp_code_actions, { desc = 'code actions' })
  vim.keymap.set('n', '<leader>s"', FzfLua.registers, { desc = "registers" })

  -- git
  vim.keymap.set('n', '<leader>gg', "<cmd>Git<cr>", { desc = 'git' })

  -- lsp
  vim.keymap.set('n', 'grt', vim.lsp.buf.type_definition, { noremap = true, silent = true, desc = 'type_definition' })
  vim.keymap.set('n', '<leader>cc', vim.lsp.codelens.run, { desc = 'codelens' })
  vim.keymap.set('n', '<leader>cC', vim.lsp.codelens.refresh, { desc = 'codelens refresh' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true, desc = 'hover' })
  vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = 'signature_help' })
  vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = 'signature_help' })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })

  -- overseer
  vim.keymap.set('n', '<leader>ot', "<cmd>OverseerTaskAction<cr>", { desc = 'OverseerTaskAction' })
  vim.keymap.set('n', '<leader>oo', "<cmd>OverseerToggle<cr>", { desc = 'OverseerToggle' })
  vim.keymap.set('n', '<leader>or', "<cmd>OverseerRun<cr>", { desc = 'OverseerRun' })

  vim.keymap.set('n', '<f4><f4>', FzfLua.commands, { desc = "commands" })

  -- config edit
  vim.keymap.set('n', '<leader>e', function()
    vim.cmd('edit ' .. vim.fn.expand('~/jhconfig/nvim/init.lua'))
    print("open init.lua")
  end, { desc = 'Edit Neovim config' })
  vim.keymap.set('n', '<leader>,p', function ()
    vim.cmd('edit ' .. vim.fn.expand('~/.config/nvim/lua/user/plugins_notvscode/a.lua'))
  end, { desc = 'open plugins' })

  vim.keymap.set('n', '<leader>fpcd', "<cmd>cd %:h<cr>", { desc = "cd to file path" })
  vim.keymap.set('n', '<leader>f.', "<cmd>e %:h<cr>", { desc = "open file's directory" })

  vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

  -- require('nvim-lspconfig')
  vim.lsp.set_log_level("debug")
  -- lsp
  vim.lsp.config("gopls", {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = true,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      }
    },
  })
  vim.lsp.enable("gopls")

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
      vim.lsp.buf.format()
    end,
  })

  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = {
          enable = false,
          globals = { "vim" }

        },
      },
    },
  })
  vim.lsp.enable("lua_ls")

  vim.lsp.inlay_hint.enable()

  vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
  vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })

  -- add function that run "aichat" to generate git message ai!

end
