-- jnvui init.lua
-- Main entry point for jnvui framework

local M = {}

-- Import modules
M.component = require("jnvui.component")
M.state = require("jnvui.state")
M.render = require("jnvui.render")
M.events = require("jnvui.events")
M.dom = require("jnvui.dom")
M.utils = require("jnvui.utils")

---Create a component (alias)
---@param name string component name
---@param render_fn fun(props: table): table render function
---@return table component
function M.createComponent(name, render_fn)
  return M.component.create(name, render_fn)
end

---Create an element (alias)
---@param type string element type
---@param props table|nil element props
---@param ... table children
---@return table element
function M.element(type, props, ...)
  return M.component.element(type, props, ...)
end

---useState hook (alias)
---@param initialValue any
---@return any, function
function M.useState(initialValue)
  return M.state.useState(initialValue)
end

---Mount a component to a buffer
---@param component table component to mount
---@param buf number buffer number
---@param props table|nil component props
---@param position table|nil {row, col} position
function M.mount(component, buf, props, position)
  props = props or {}
  position = position or {row = 0, col = 0}

  local ctx = M.component.create_context(component)
  M.state.set_context(ctx)

  local element = component.render(props)
  M.render.render(element, buf, ctx.namespace, position)

  M.state.set_context(nil)

  return {
    component = component,
    buffer = buf,
    namespace = ctx.namespace,
    position = position,
    update = function(new_props)
      M.mount(component, buf, new_props or props, position)
    end,
  }
end

---Unmount a component
---@param instance table component instance
function M.unmount(instance)
  M.render.clear_namespace(instance.buffer, instance.namespace)
  M.events.clear_mappings()
end

return M
