-- jnvui dom.lua
-- Virtual DOM and diffing algorithm

local M = {}

---Compare two elements for equality
---@param a JnvuiElement|nil
---@param b JnvuiElement|nil
---@return boolean
function M.elements_equal(a, b)
  if a == nil and b == nil then
    return true
  end
  if a == nil or b == nil then
    return false
  end

  if a.type ~= b.type then
    return false
  end

  if a.key ~= b.key then
    return false
  end

  return true
end

---Diff two element trees and return patches
---@param old_tree JnvuiElement|nil
---@param new_tree JnvuiElement|nil
---@return table patches list of patch operations
function M.diff(old_tree, new_tree)
  local patches = {}

  if not old_tree and not new_tree then
    return patches
  end

  if not old_tree then
    table.insert(patches, {op = "create", element = new_tree})
    return patches
  end

  if not new_tree then
    table.insert(patches, {op = "remove", element = old_tree})
    return patches
  end

  if not M.elements_equal(old_tree, new_tree) then
    table.insert(patches, {op = "replace", old = old_tree, new = new_tree})
    return patches
  end

  local prop_patches = M.diff_props(old_tree.props, new_tree.props)
  if #prop_patches > 0 then
    table.insert(patches, {op = "props", element = new_tree, changes = prop_patches})
  end

  local child_patches = M.diff_children(old_tree.children, new_tree.children)
  for _, patch in ipairs(child_patches) do
    table.insert(patches, patch)
  end

  return patches
end

---Diff props between two elements
---@param old_props JnvuiProps
---@param new_props JnvuiProps
---@return table changes list of prop changes
function M.diff_props(old_props, new_props)
  local changes = {}
  old_props = old_props or {}
  new_props = new_props or {}

  for key, new_val in pairs(new_props) do
    if old_props[key] ~= new_val then
      table.insert(changes, {key = key, old = old_props[key], new = new_val})
    end
  end

  for key, _ in pairs(old_props) do
    if new_props[key] == nil then
      table.insert(changes, {key = key, old = old_props[key], new = nil})
    end
  end

  return changes
end

---Diff children arrays
---@param old_children JnvuiElement[]
---@param new_children JnvuiElement[]
---@return table patches
function M.diff_children(old_children, new_children)
  local patches = {}
  old_children = old_children or {}
  new_children = new_children or {}

  local max_len = math.max(#old_children, #new_children)

  for i = 1, max_len do
    local old_child = old_children[i]
    local new_child = new_children[i]
    local child_patches = M.diff(old_child, new_child)
    for _, patch in ipairs(child_patches) do
      patch.index = i
      table.insert(patches, patch)
    end
  end

  return patches
end

return M
