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
---@return any|nil, fun(newValue: any)|nil current value and setter, or nil on error
function M.useState(initialValue)
  if not current_context then
    vim.notify("jnvui: useState must be called within a component render", vim.log.levels.ERROR)
    return nil, nil
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
        local success, err = pcall(ctx.currentComponent.onUpdate)
        if not success then
          vim.notify("jnvui: State update error: " .. tostring(err), vim.log.levels.ERROR)
        end
      end
    end
  end

  hook.setValue = setValue
  return hook.value, setValue
end

return M
