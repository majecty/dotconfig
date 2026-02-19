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

---@class JnvuiTextProps
---@field content string text content to display
---@field highlight string|nil highlight group name

---@class JnvuiBoxProps
---@field width number|nil box width in characters
---@field height number|nil box height in lines
---@field border string|nil border style ("single", "double", "rounded")

---@class JnvuiButtonProps
---@field label string button label text
---@field onClick function|nil click event handler
---@field highlight string|nil highlight group name

---@class JnvuiInputProps
---@field placeholder string|nil placeholder text
---@field value string|nil current input value
---@field onChange function|nil change event handler
---@field highlight string|nil highlight group name

---@class JnvuiRowProps
---@field spacing number|nil spacing between children
---@field highlight string|nil highlight group name

---@class JnvuiColumnProps
---@field spacing number|nil spacing between children
---@field highlight string|nil highlight group name

---@class JnvuiVirtualTextChunk
---@field text string the text to display
---@field hl_group string|nil highlight group name

---@alias JnvuiElementType "text" | "box" | "button" | "input" | "row" | "column"

---@class JnvuiElement
---@field type JnvuiElementType element type identifier
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
