-- local config = require("jhui.config")
-- 
local M = {}

function M.hello()
  print("hello world")
end

vim.api.nvim_create_user_command('JH', function()
  M.hello()
end, { desc = "Print hello world from jhui" })


function M.onBufEnter()
    vim.api.nvim_echo({{"[jhui] onBufEnter", "None"}}, false, {})
--   print("onBufEnter")
end

return M