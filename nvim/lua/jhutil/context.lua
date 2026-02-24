---@class Context
---@field effects jh.Effect[] | number[]
Context.__index = Context

function Context.new()
  return setmetatable({
    effects = {},
  }, Context)
end

function Context:add_effect(effect)
  table.insert(self.effects, effect)
end

---@return jh.Effect[]
function Context:get_effects()
  return self.effects
end

function Context:apply()
  for _, effect in ipairs(self.effects) do
    self:execute(effect)
  end
  self.effects = {}
end

---@class jh.Effect
---@field type string

---@alias jh.WinSetBufEffect { type: "win_set_buf", win_id: number, buf_id: number }
---@alias jh.WinSetCursorEffect { type: "win_set_cursor", win_id: number, line: number, col: number }
---@alias jh.WinFocusEffect { type: "win_focus", win_id: number }
---@alias jh.WinCloseEffect { type: "win_close", win_id: number, force: boolean }

function Context:execute(effect)
  if effect.type == "win_set_buf" then
    vim.api.nvim_win_set_buf(effect.win_id, effect.buf_id)
  elseif effect.type == "win_set_cursor" then
    vim.api.nvim_win_set_cursor(effect.win_id, { effect.line, effect.col })
  elseif effect.type == "win_focus" then
    vim.api.nvim_set_current_win(effect.win_id)
  elseif effect.type == "win_close" then
    vim.api.nvim_win_close(effect.win_id, effect.force)
  end
end

---@class ContextTab
---@field id number
---@field context Context
local ContextTab = {}
ContextTab.__index = ContextTab

---@return ContextTab
function ContextTab.new(id, context)
  return setmetatable({
    id = id,
    context = context,
  }, ContextTab)
end

function ContextTab:get_window_ids()
  return vim.api.nvim_tabpage_list_wins(self.id)
end

function ContextTab:get_windows()
  local window_ids = self:get_window_ids()
  local windows = {}
  for _, win_id in ipairs(window_ids) do
    table.insert(windows, ContextWindow.new(win_id, self.context))
  end
  return windows
end

---@alias j.tab.layout.ret
--- | vim.fn.winlayout.leaf
--- | vim.fn.winlayout.branch
--- | vim.fn.winlayout.empty

---@return j.tab.layout.ret
function ContextTab:layout()
  return vim.fn.winlayout(self.id)
end

---@class ContextWindow
---@field id number
---@field context Context
local ContextWindow = {}
ContextWindow.__index = ContextWindow

function ContextWindow.new(id, context)
  return setmetatable({
    id = id,
    context = context,
  }, ContextWindow)
end

function ContextWindow.__eq(self, other)
  if getmetatable(self) ~= ContextWindow or getmetatable(other) ~= ContextWindow then
    return false
  end
  return self.id == other.id
end

function ContextWindow:get_buffer()
  local buf_id = vim.api.nvim_win_get_buf(self.id)
  return ContextBuffer.new(buf_id, self.context)
end

function ContextWindow:set_buffer(buffer)
  self.context:add_effect({
    type = "win_set_buf",
    win_id = self.id,
    buf_id = buffer.id,
  })
end

function ContextWindow:get_cursor()
  local cursor_pos = vim.api.nvim_win_get_cursor(self.id)
  return setmetatable({
    line = cursor_pos[1],
    col = cursor_pos[2],
  }, ContextCursor)
end

function ContextWindow:set_cursor(cursor)
  self.context:add_effect({
    type = "win_set_cursor",
    win_id = self.id,
    line = cursor.line,
    col = cursor.col,
  })
end

function ContextWindow:focus()
  self.context:add_effect({
    type = "win_focus",
    win_id = self.id,
  })
end

function ContextWindow:close(args)
  args = args or {}
  local force = args.force or false
  self.context:add_effect({
    type = "win_close",
    win_id = self.id,
    force = force,
  })
end

---@class ContextBuffer
---@field id number
---@field context Context
local ContextBuffer = {}
ContextBuffer.__index = ContextBuffer

function ContextBuffer.new(id, context)
  return setmetatable({
    id = id,
    context = context,
  }, ContextBuffer)
end

function ContextBuffer:get_cursor()
  local cursor_pos = vim.api.nvim_buf_get_mark(self.id, ".")
  return setmetatable({
    line = cursor_pos[1],
    col = cursor_pos[2],
  }, ContextCursor)
end

---@class ContextCursor
---@field line number
---@field col number
local ContextCursor = {}
ContextCursor.__index = ContextCursor

local function current_tab(context)
  local current_tab_id = vim.api.nvim_get_current_tabpage()
  return ContextTab.new(current_tab_id, context)
end

local function current_window(context)
  local current_window_id = vim.api.nvim_get_current_win()
  return ContextWindow.new(current_window_id, context)
end

return {
  new = function()
    local ctx = Context.new()
    return {
      b = {},
      t = {
        current = function()
          return current_tab(ctx)
        end,
      },
      w = {
        current = function()
          return current_window(ctx)
        end,
        from_id = function(id)
          assert(type(id) == "number", "Window ID is required in j.w.from_id " .. id)
          return ContextWindow.new(id, ctx)
        end,
      },
      get_effects = function()
        return ctx:get_effects()
      end,
      apply = function()
        ctx:apply()
      end,
    }
  end,
}