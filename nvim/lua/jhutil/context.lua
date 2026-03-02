

---@alias jh.envKey string
---@alias jh.kind "current_tab" | "current_window" | "current_buffer"

---@class Context
---@field effects jh.Effect[]
---@field env { [string]: { kind: jh.kind, value: any } }
--[[
ENV(placeholder) 설계 요약

- 목적: 임시 자리표시자(Placeholder)를 context 단위로 보관
- 구조: key는 고유 문자열, 값은 `{ kind = <string>, value = <any> }`
- 사용 패턴:
  1) `make_placeholder(context, kind)`으로 생성 → env에 `{kind, value=UNKNOWN}` 저장, 키 리턴
  2) effect에서 key(문자열)로 placeholder 참조(예: `win_id = key`)
  3) execute 타이밍에 필요한 placeholder만 평가(resolve)해서 실제값으로 치환
- 구조 예시: `{ kind = "current_tab", value = UNKNOWN }` (value가 UNKNOWN이면 미평가)
- 특징: 키 충돌 최소화(불투명 문자열), 여러 effect에 동일 placeholder 공유 가능
- 확장: kind별 평가 로직 추가로 다양한 상황 대응 가능
]]
local Context = {}
Context.__index = Context

---@class ContextWindow
---@field id number
---@field context Context
local ContextWindow = {}
ContextWindow.__index = ContextWindow

---@class ContextBuffer
---@field id number
---@field context Context
local ContextBuffer = {}
ContextBuffer.__index = ContextBuffer

---@class ContextCursor
---@field line number
---@field col number
local ContextCursor = {}
ContextCursor.__index = ContextCursor



-- unknown 마커: evaluate 시 실제 값으로 교체할 목적의 자리표시자
local UNKNOWN = {}

-- helper: create a placeholder entry in context.env and return its key
local function random_key()
  return tostring(vim.uv.hrtime()) .. '-' .. tostring(math.random()) .. '-' .. tostring({})
end

---@param context Context
---@param kind string
local function make_placeholder(context, kind)
  context.env = context.env or {}
  local key = random_key()
  context.env[key] = { kind = kind, value = UNKNOWN }
  return key
end

-- resolve a single placeholder key into a concrete value (evaluates UNKNOWN)
function Context:resolve_placeholder_key(key)
  if not self.env then
    return nil
  end
  local entry = self.env[key]
  if not entry then
    return nil
  end
  if entry.value ~= UNKNOWN then
    return entry.value
  end
  -- evaluate based on kind
  local val
  if entry.kind == 'current_tab' then
    val = vim.api.nvim_get_current_tabpage()
  elseif entry.kind == 'current_window' then
    val = vim.api.nvim_get_current_win()
  elseif entry.kind == 'current_buffer' then
    val = vim.api.nvim_get_current_buf()
  else
    -- unknown kind: leave as nil
    val = nil
  end
  entry.value = val
  return val
end

-- resolve placeholders present in an effect table (shallow)
function Context:resolve_effect_placeholders(effect)
  for field, v in pairs(effect) do
    if type(v) == 'string' and self.env and self.env[v] then
      local real = self:resolve_placeholder_key(v)
      if real ~= nil then
        effect[field] = real
      end
    end
  end
end

function Context.new()
  return setmetatable({
    effects = {},
    env = {},
  }, Context)
end

---@param effect jh.Effect
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
  if effect.type == 'win_set_buf' then
    vim.api.nvim_win_set_buf(effect.win_id, effect.buf_id)
  elseif effect.type == 'win_set_cursor' then
    vim.api.nvim_win_set_cursor(effect.win_id, { effect.line, effect.col })
  elseif effect.type == 'win_focus' then
    vim.api.nvim_set_current_win(effect.win_id)
  elseif effect.type == 'win_close' then
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

---@return j.tab.layout.ret
function ContextTab:layout()
  return vim.fn.winlayout(self.id)
end

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
    type = 'win_set_buf',
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
    type = 'win_set_cursor',
    win_id = self.id,
    line = cursor.line,
    col = cursor.col,
  })
end

function ContextWindow:focus()
  self.context:add_effect({
    type = 'win_focus',
    win_id = self.id,
  })
end

function ContextWindow:close(args)
  args = args or {}
  local force = args.force or false
  self.context:add_effect({
    type = 'win_close',
    win_id = self.id,
    force = force,
  })
end

function ContextBuffer.new(id, context)
  return setmetatable({
    id = id,
    context = context,
  }, ContextBuffer)
end

function ContextBuffer:get_cursor()
  local cursor_pos = vim.api.nvim_buf_get_mark(self.id, '.')
  return setmetatable({
    line = cursor_pos[1],
    col = cursor_pos[2],
  }, ContextCursor)
end

local function current_tab(context)
  -- minimal: env에 랜덤 키를 만들어 UNKNOWN 자리표시자로 넣어둡니다.
  -- 이 자리표시자는 later effects에서 키 문자열을 사용해 참조할 수 있습니다.
  make_placeholder(context, 'current_tab')

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
          assert(type(id) == 'number', 'Window ID is required in j.w.from_id ' .. id)
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
