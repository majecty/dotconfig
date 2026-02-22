---@class Tab
---@field id number
local Tab = {}
Tab.__index = Tab

---@class Window
---@field id number
local Window = {}
Window.__index = Window

---@class Buffer
---@field id number
local Buffer = {}
Buffer.__index = Buffer

---@class Cursor
---@field line number
---@field col number
local Cursor = {}
Cursor.__index = Cursor

---@return Tab
local function current_tab()
  local current_tab_id = vim.api.nvim_get_current_tabpage()
  return setmetatable({
    id = current_tab_id
  }, Tab)
end

---@return number[] List of window IDs in the tab
function Tab:get_window_ids()
  return vim.api.nvim_tabpage_list_wins(self.id)
end


---@return Window
local function current_window()
  local current_window_id = vim.api.nvim_get_current_win()
  return setmetatable({
    id = current_window_id
  }, Window)
end

function Buffer.new(id)
  return setmetatable({
    id = id
  }, Buffer)
end


---@return boolean
function Window.__eq(self, other)
  if getmetatable(self) ~= Window or getmetatable(other) ~= Window then
    return false
  end
  return self.id == other.id
end

function Window:get_buffer()
  local buf_id = vim.api.nvim_win_get_buf(self.id)
  return Buffer.new(buf_id)
end

function Window:set_buffer(buffer)
  vim.api.nvim_win_set_buf(self.id, buffer.id)
end

function Window:get_cursor()
  local cursor_pos = vim.api.nvim_win_get_cursor(self.id)
  return setmetatable({
    line = cursor_pos[1],
    col = cursor_pos[2]
  }, Cursor)
end

function Window:set_cursor(cursor)
  vim.api.nvim_win_set_cursor(self.id, { cursor.line, cursor.col })
end

function Window:focus()
  vim.api.nvim_set_current_win(self.id)
end


return  {
  b = {

  },
  t = {
    current = function ()
      return current_tab()
    end
  },
  w = {
    current = function ()
      return current_window()
    end
  },
}

