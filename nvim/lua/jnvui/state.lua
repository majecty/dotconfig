-- jnvui state.lua
-- State management with useState hook

local M = {}

---@type JnvuiContext|nil
local current_context = nil

---@type table<number, JnvuiContext>
local component_contexts = {}

---Set the current rendering context
---@param context JnvuiContext|nil
function M.set_context(context)
  current_context = context
  if context then
    context.hookIndex = 0
  end
end

---Get the current rendering context
---@return JnvuiContext|nil
function M.get_context()
  return current_context
end

---Reset hook index for re-render
function M.reset_hooks()
  if current_context then
    current_context.hookIndex = 0
  end
end

---useState hook implementation
---@param initialValue any initial state value
---@return any, fun(newValue: any) current value and setter
function M.useState(initialValue)
  if not current_context then
    error("useState must be called within a component render")
  end

  local ctx = current_context
  local hookIndex = ctx.hookIndex + 1
  ctx.hookIndex = hookIndex

  if not ctx.hooks[hookIndex] then
    ctx.hooks[hookIndex] = {
      value = initialValue,
      index = hookIndex,
    }
  end

  local hook = ctx.hooks[hookIndex]

  ---@param newValue any
  local function setValue(newValue)
    if hook.value ~= newValue then
      hook.value = newValue
      if ctx.currentComponent and ctx.currentComponent.onUpdate then
        ctx.currentComponent.onUpdate()
      end
    end
  end

  hook.setValue = setValue
  return hook.value, setValue
end

return M
