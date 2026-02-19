-- jnvui events.lua
-- Event handling system

local M = {}

---@type table<string, table<string, function[]>> event type -> element key -> handlers
local event_handlers = {}

---@type table<number, JnvuiElement> extmark id -> element mapping
local mark_to_element = {}

---Register an event handler
---@param event_type string event type (click, input, etc.)
---@param element_key string unique element identifier
---@param handler function callback function
function M.on(event_type, element_key, handler)
  if not event_handlers[event_type] then
    event_handlers[event_type] = {}
  end
  if not event_handlers[event_type][element_key] then
    event_handlers[event_type][element_key] = {}
  end
  table.insert(event_handlers[event_type][element_key], handler)
end

---Remove event handlers
---@param event_type string|nil event type (nil for all)
---@param element_key string|nil element key (nil for all)
function M.off(event_type, element_key)
  if not event_type then
    event_handlers = {}
    return
  end
  if not element_key then
    event_handlers[event_type] = nil
    return
  end
  if event_handlers[event_type] then
    event_handlers[event_type][element_key] = nil
  end
end

---Trigger an event
---@param event_type string event type
---@param element_key string element identifier
---@param data any event data
function M.trigger(event_type, element_key, data)
  local handlers = event_handlers[event_type] and event_handlers[event_type][element_key]
  if handlers then
    for _, handler in ipairs(handlers) do
      local success, err = pcall(handler, data)
      if not success then
        vim.notify("Event handler error: " .. tostring(err), vim.log.levels.ERROR)
      end
    end
  end
end

---Map extmark to element for event routing
---@param mark_id number extmark id
---@param element JnvuiElement element reference
function M.map_mark_to_element(mark_id, element)
  mark_to_element[mark_id] = element
end

---Get element by extmark id
---@param mark_id number
---@return JnvuiElement|nil
function M.get_element_by_mark(mark_id)
  return mark_to_element[mark_id]
end

---Clear all event mappings
function M.clear_mappings()
  mark_to_element = {}
end

return M
