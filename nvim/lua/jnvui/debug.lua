-- jnvui debug.lua
-- Debugging utilities for jnvui

local M = {}

---Print element tree structure
---@param element JnvuiElement|nil element to print
---@param indent number|nil current indentation level
---@param prefix string|nil prefix for current line
function M.print_tree(element, indent, prefix)
  indent = indent or 0
  prefix = prefix or ""

  if not element then
    print(string.rep("  ", indent) .. prefix .. "nil")
    return
  end

  local indent_str = string.rep("  ", indent)
  local type_str = element.type or "unknown"

  -- Build props summary
  local props_summary = ""
  if element.props then
    local prop_parts = {}
    for k, v in pairs(element.props) do
      if type(v) == "string" and #v <= 20 then
        table.insert(prop_parts, k .. "=\"" .. v .. "\"")
      elseif type(v) == "number" then
        table.insert(prop_parts, k .. "=" .. v)
      elseif type(v) == "boolean" then
        table.insert(prop_parts, k .. "=" .. tostring(v))
      elseif type(v) == "function" then
        table.insert(prop_parts, k .. "=fn")
      end
    end
    if #prop_parts > 0 then
      props_summary = " [" .. table.concat(prop_parts, ", ") .. "]"
    end
  end

  -- Print current element
  print(indent_str .. prefix .. type_str .. props_summary)

  -- Print children
  if element.children and #element.children > 0 then
    for i, child in ipairs(element.children) do
      local is_last = (i == #element.children)
      local child_prefix = is_last and "└── " or "├── "
      M.print_tree(child, indent + 1, child_prefix)
    end
  end
end

---Convert element tree to string representation
---@param element JnvuiElement|nil element to convert
---@param indent number|nil current indentation level
---@param prefix string|nil prefix for current line
---@return string tree representation
function M.tree_to_string(element, indent, prefix)
  indent = indent or 0
  prefix = prefix or ""

  if not element then
    return string.rep("  ", indent) .. prefix .. "nil\n"
  end

  local indent_str = string.rep("  ", indent)
  local type_str = element.type or "unknown"

  -- Build props summary
  local props_summary = ""
  if element.props then
    local prop_parts = {}
    for k, v in pairs(element.props) do
      if type(v) == "string" and #v <= 20 then
        table.insert(prop_parts, k .. "=\"" .. v .. "\"")
      elseif type(v) == "number" then
        table.insert(prop_parts, k .. "=" .. v)
      elseif type(v) == "boolean" then
        table.insert(prop_parts, k .. "=" .. tostring(v))
      elseif type(v) == "function" then
        table.insert(prop_parts, k .. "=fn")
      end
    end
    if #prop_parts > 0 then
      props_summary = " [" .. table.concat(prop_parts, ", ") .. "]"
    end
  end

  -- Build current line
  local result = indent_str .. prefix .. type_str .. props_summary .. "\n"

  -- Add children
  if element.children and #element.children > 0 then
    for i, child in ipairs(element.children) do
      local is_last = (i == #element.children)
      local child_prefix = is_last and "└── " or "├── "
      result = result .. M.tree_to_string(child, indent + 1, child_prefix)
    end
  end

  return result
end

---Inspect element and return detailed info
---@param element JnvuiElement|nil element to inspect
---@return table info element information
function M.inspect(element)
  if not element then
    return {type = "nil", props = {}, children_count = 0}
  end

  local info = {
    type = element.type,
    props = {},
    children_count = #element.children,
    has_key = element.key ~= nil,
    has_position = element.position ~= nil,
  }

  -- Copy props (excluding functions)
  if element.props then
    for k, v in pairs(element.props) do
      if type(v) ~= "function" then
        info.props[k] = v
      else
        info.props[k] = "<function>"
      end
    end
  end

  return info
end

return M
