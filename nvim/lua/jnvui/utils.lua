-- jnvui utils.lua
-- Utility functions for jnvui framework

local M = {}

---Generate a unique ID
---@return string unique identifier
function M.generate_id()
  return tostring(math.random(100000, 999999))
end

---Deep copy a table
---@param obj table table to copy
---@return table copied table
function M.deep_copy(obj)
  if type(obj) ~= "table" then
    return obj
  end
  local copy = {}
  for k, v in pairs(obj) do
    copy[M.deep_copy(k)] = M.deep_copy(v)
  end
  return copy
end

---Merge two tables (shallow)
---@param t1 table base table
---@param t2 table table to merge
---@return table merged table
function M.merge_tables(t1, t2)
  local result = {}
  for k, v in pairs(t1 or {}) do
    result[k] = v
  end
  for k, v in pairs(t2 or {}) do
    result[k] = v
  end
  return result
end

---Check if value is in array
---@param arr table array to search
---@param val any value to find
---@return boolean
function M.contains(arr, val)
  for _, v in ipairs(arr) do
    if v == val then
      return true
    end
  end
  return false
end

return M
