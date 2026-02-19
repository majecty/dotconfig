-- jnvui c.lua
-- Component shortcuts for jnvui
-- Usage: jnvui.c.text({content = "Hello"})

local M = {}

---Create a text element
---@param props table element properties
---@return JnvuiElement
function M.text(props)
  return require("jnvui").element("text", props)
end

---Create a box element
---@param props table element properties
---@param ... JnvuiElement children elements
---@return JnvuiElement
function M.box(props, ...)
  return require("jnvui").element("box", props, ...)
end

---Create a button element
---@param props table element properties
---@return JnvuiElement
function M.button(props)
  return require("jnvui").element("button", props)
end

---Create an input element
---@param props table element properties
---@return JnvuiElement
function M.input(props)
  return require("jnvui").element("input", props)
end

---Create a row container
---@param props table element properties
---@param ... JnvuiElement children elements
---@return JnvuiElement
function M.row(props, ...)
  return require("jnvui").element("row", props, ...)
end

---Create a column container
---@param props table element properties
---@param ... JnvuiElement children elements
---@return JnvuiElement
function M.column(props, ...)
  return require("jnvui").element("column", props, ...)
end

return M
