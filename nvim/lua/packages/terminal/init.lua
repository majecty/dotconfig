-- Terminal configuration package
local M = {}

function M.setup()
  -- Terminal mode keybindings
  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
  vim.keymap.set('t', '<S-Esc>', '<Esc>', { noremap = true })
end

return M
