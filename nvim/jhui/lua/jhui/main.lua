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
    local buf = vim.api.nvim_create_buf(true, true) -- listed, scratch
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, {"hello", "button"})

    -- make buffer readonly
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "readonly", true)

    vim.api.nvim_open_win(buf, true, {
        relative = "win",
        width = 100,
        height = 100,
        row = 0,
        col = 0,
    })
    
    vim.keymap.set('n', '<CR>', function()
        M._on_enter()
    end, { buffer = buf })
end

function M._on_enter()
    local cur = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    if line == "hello" then
        print("hello")
    end
end

vim.api.nvim_create_user_command('JHOpen', function()
    M.open()
end, { desc = "Open the jhui buffer" })

vim.keymap.set('n', '<leader>o', function()
    M.open()
end, { desc = "Open the jhui buffer" })

vim.keymap.set('n', '<leader>r', function()
    package.loaded['jhui.main'] = nil
    require('jhui.main')
    vim.notify("jhui plugin reloaded", vim.log.levels.INFO)
end, { desc = "Reload the jhui plugin" })

return M