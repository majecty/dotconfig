-- jnvui component.lua
-- Component system for jnvui framework

local state = require("jnvui.state")
local utils = require("jnvui.utils")

local M = {}

---@type table<string, JnvuiComponent>
local registered_components = {}

---@type number
local namespace_counter = 0

---Create a new namespace for extmarks
---@return number namespace id
function M.create_namespace()
  namespace_counter = namespace_counter + 1
  return vim.api.nvim_create_namespace("jnvui_" .. namespace_counter)
end

---Create a component
---@param name string component name
---@param render_fn fun(props: JnvuiProps): JnvuiElement render function
---@return JnvuiComponent
function M.create(name, render_fn)
  ---@type JnvuiComponent
  local component = {
    name = name,
    render = render_fn,
  }
  registered_components[name] = component
  return component
end

---Create a context for component rendering
---@param component JnvuiComponent
---@return JnvuiContext
function M.create_context(component)
  return {
    currentComponent = component,
    hookIndex = 0,
    hooks = {},
    namespace = M.create_namespace(),
  }
end

---Create an element
---@param type string element type
---@param props JnvuiProps|nil element props
---@param ... JnvuiElement children
---@return JnvuiElement
function M.element(type, props, ...)
  ---@type JnvuiElement
  local element = {
    type = type,
    props = props or {},
    children = {...},
  }
  return element
end

---Render a component to element tree
---@param component JnvuiComponent
---@param props JnvuiProps
---@return JnvuiElement|nil element or nil on error
function M.render_component(component, props)
  if not component then
    vim.notify("jnvui: Cannot render nil component", vim.log.levels.ERROR)
    return nil
  end

  if not component.render then
    vim.notify("jnvui: Component " .. tostring(component.name) .. " has no render function", vim.log.levels.ERROR)
    return nil
  end

  local ctx = M.create_context(component)
  state.set_context(ctx)

  local success, result = pcall(component.render, props)

  state.set_context(nil)

  if not success then
    vim.notify("jnvui: Component " .. component.name .. " render failed: " .. tostring(result), vim.log.levels.ERROR)
    return nil
  end

  return result
end

return M
