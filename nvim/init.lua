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

-- Minimal ctrl-s Save in all modes
vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { silent = true })
vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>gv', { silent = true })

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

  vim.keymap.set({'n', 'x'}, '<C-S-V>', '"+p', { desc = 'Paste system clipboard' })
  -- 비주얼, 노멀 모드: Ctrl+Shift+C로 복사
  vim.keymap.set({'n', 'x'}, '<C-S-C>', '"+y', { desc = 'Copy system clipboard' })
  -- 인서트 모드: Ctrl+Shift+V로 붙여넣기
  vim.keymap.set('i', '<C-S-V>', '<ESC>"+pa', { desc = 'Paste clipboard (insert mode)' })

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
  vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>wq', '<cmd>wq<cr>', { noremap = true, silent = true, desc = 'save and quit' })
  vim.keymap.set('n', '<leader>ww', '<cmd>w<cr>', { noremap = true, silent = true, desc = 'save' })

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
  vim.keymap.set('n', '<leader>gp', FzfLua.grep_project, { desc = 'grep project' })

  -- git
  vim.keymap.set('n', '<leader>gg', "<cmd>Git<cr>", { desc = 'git' })

   -- Minimal LSP config
   -- Uncomment below if you want default LSP
   -- require('nvim-lspconfig')
   -- You can configure servers in plugin files

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
   vim.keymap.set('n', '<leader>-', require('oil').open, { desc = 'Open Oil Directory Browser' })


  vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

   -- Minimal LSP config
   -- Uncomment below if you want default LSP
   -- require('nvim-lspconfig')
   -- You can configure servers in plugin files

 end
