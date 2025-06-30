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
end


require("config.lazy")

vim.api.nvim_echo({{"[nvim/init.lua] loaded", "None"}}, false, {})

if vim.g.vscode then
else
  vim.keymap.set('n', '<leader>b', "<cmd>Buffers<cr>", { desc = 'buffers' })
  vim.keymap.set('n', '<leader>gg', "<cmd>Git<cr>", { desc = 'git' })

  vim.keymap.set('n', '<leader>,p', function ()
    vim.cmd('edit ' .. vim.fn.expand('~/.config/nvim/lua/user/plugins_notvscode/a.lua'))
  end, { desc = 'open plugins' })

  vim.keymap.set('n', '<f4><f4>', "<cmd>Commands<cr>", { desc = "commands" })
  vim.keymap.set('n', '<leader>e', function()
    vim.cmd('edit ' .. vim.fn.expand('~/.config/nvim/init.lua'))
    print("open init.lua")
  end, { desc = 'Edit Neovim config' })
  vim.keymap.set('n', '<leader>fpcd', "<cmd>cd %:h<cr>", { desc = "cd to file path" })

  vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

  vim.lsp.enable("gopls")
  vim.lsp.enable("lua_ls")
end
