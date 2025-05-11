-- local config = require("jhui.config")
-- 
local M = {}

function M.hello()
  print("hello world")
end

vim.api.nvim_create_user_command('JH', function()
  M.hello()
end, { desc = "Print hello world from jhui" })

-- create a new buffer and open it
function M.open()
    
    -- create an empty buffer and write hello to it
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, {"hello"})
    -- open the buffer
    vim.api.nvim_open_win(buf, true, {
        split = "right",
    })
end

vim.api.nvim_create_user_command('JHOpen', function()
    M.open()
end, { desc = "Open the jhui buffer" })

vim.keymap.set('n', '<leader>o', function()
    M.open()
end, { desc = "Open the jhui buffer" })

vim.keymap.set('n', '<leader>rj', function()
    package.loaded['jhui.main'] = nil
    require('jhui.main')
    vim.notify("jhui plugin reloaded", vim.log.levels.INFO)
end, { desc = "Reload the jhui plugin" })

return M