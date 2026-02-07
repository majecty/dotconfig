-- local config = require("jhui.config")
-- 
local M = {}
local UI = {}
local Component = {}
local Button = {}

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
    
    local ui = UI:new()
    ui:add_component(Button:new("hello", function() 
        print("hello")
    end))
    ui:add_component(Button:new("world", function() 
        print("world")
    end))
    
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, ui:render())

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
        ui:on_enter()
    end, { buffer = buf })
    
    vim.keymap.set('n', 'h', function()
        ui:debug_render()
    end, { buffer = buf })
end

vim.api.nvim_create_user_command('JHOpen', function()
    M.open()
end, { desc = "Open the jhui buffer" })



function Button:new(text, on_enter)
    local self = setmetatable({}, { __index = Button })
    self.text = text
    self.on_enter = on_enter
    return self
end

function Button:render()
    return self.text
end

function UI:new()
    local self = setmetatable({}, { __index = UI })
    self.components = {}
    return self
end

function UI:add_component(component)
    table.insert(self.components, component)
end

function UI:render()
    local rendered = {}
    for _, component in ipairs(self.components) do
        table.insert(rendered, component:render())
    end
    return rendered
end

function UI:on_enter()
    -- get cursor position
    local cur = vim.api.nvim_win_get_cursor(0)
    -- print(cur[1], cur[2])
    
    local component_start = {1, 0}
    for _, component in ipairs(self.components) do
        local component_end = {
            component_start[1],
            component_start[2] + #component:render()
        }
        if cur[1] >= component_start[1] and cur[1] <= component_end[1] and cur[2] >= component_start[2] and cur[2] <= component_end[2] then
            component:on_enter()
            break
        end
        component_start = {
            component_end[1] + 1,
            0
        }
    end
end

function UI:debug_render()
    -- get cursor position
    local cur = vim.api.nvim_win_get_cursor(0)
    -- print(cur[1], cur[2])
    -- 
    local rendered = {}
    rendered.cursor = {
        x = cur[1],
        y = cur[2]
    }
    
    local component_start = {1, 0}
    for _, component in ipairs(self.components) do
        local component_end = {
            component_start[1],
            component_start[2] + #component:render()
        }
        table.insert(rendered, {
            startX = component_start[1],
            startY = component_start[2],
            endX = component_end[1],
            endY = component_end[2],
            text = component:render()
        })
        component_start = {
            component_end[1] + 1,
            0
        }
    end
    
    print(vim.inspect(rendered))
end


return M
