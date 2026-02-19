-- jnvui types.lua
-- Type definitions for jnvui framework

---@class JnvuiPosition
---@field row number 0-based row index
---@field col number 0-based column index

---@class JnvuiSize
---@field width number width in characters
---@field height number height in lines

---@class JnvuiRect
---@field row number top-left row
---@field col number top-left column
---@field width number
---@field height number

---@class JnvuiProps
---@field [string] any dynamic key-value props

---@class JnvuiVirtualTextChunk
---@field text string the text to display
---@field hl_group string|nil highlight group name

---@class JnvuiElement
---@field type string element type identifier
---@field props JnvuiProps element properties
---@field children JnvuiElement[] child elements
---@field key string|nil unique key for list rendering
---@field position JnvuiPosition|nil rendered position

---@class JnvuiComponent
---@field render fun(props: JnvuiProps): JnvuiElement component render function
---@field name string component name for debugging

---@class JnvuiStateHook
---@field value any current state value
---@field setValue fun(newValue: any) state setter function
---@field index number hook index in component

---@class JnvuiEvent
---@field type string event type (click, input, etc.)
---@field target JnvuiElement element that triggered event
---@field data any event-specific data

---@class JnvuiNamespace
---@field id number extmark namespace id

---@alias JnvuiRenderer fun(element: JnvuiElement, buffer: number, namespace: number): nil

---@class JnvuiContext
---@field currentComponent JnvuiComponent|nil currently rendering component
---@field hookIndex number current hook index
---@field hooks JnvuiStateHook[] component state hooks
---@field namespace number extmark namespace id

return {}
