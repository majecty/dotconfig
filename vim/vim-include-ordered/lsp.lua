

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--local servers = { 'rust_analyzer', 'eslint', 'vuels', 'sumneko_lua' }
--for _, lsp in pairs(servers) do
  --require('lspconfig')[lsp].setup {
    --on_attach = on_attach,
    --flags = {
      ---- This will be the default in neovim 0.7+
      --debounce_text_changes = 150,
    --}
  --}
--end
