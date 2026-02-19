-- jnvui render.lua
-- Virtual text rendering engine

local M = {}

---@type table<number, table<number, number>> buffer -> namespace -> extmark ids
local active_marks = {}

---Clear all extmarks in a namespace
---@param buf number buffer number
---@param ns number namespace id
function M.clear_namespace(buf, ns)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  if not active_marks[buf] then
    active_marks[buf] = {}
  end
  active_marks[buf][ns] = {}
end

---Render virtual text at position
---@param buf number buffer number
---@param ns number namespace id
---@param row number 0-based row
---@param col number 0-based column
---@param chunks JnvuiVirtualTextChunk[] text chunks with highlights
---@return number extmark id
function M.render_text(buf, ns, row, col, chunks)
  local opts = {
    virt_text = chunks,
    virt_text_pos = "overlay",
  }

  local mark_id = vim.api.nvim_buf_set_extmark(buf, ns, row, col, opts)

  if not active_marks[buf] then
    active_marks[buf] = {}
  end
  if not active_marks[buf][ns] then
    active_marks[buf][ns] = {}
  end
  table.insert(active_marks[buf][ns], mark_id)

  return mark_id
end

---Render an element tree
---@param element JnvuiElement
---@param buf number buffer number
---@param ns number namespace id
---@param position JnvuiPosition starting position
function M.render(element, buf, ns, position)
  M.clear_namespace(buf, ns)

  if element.type == "text" then
    local text = element.props.content or ""
    local hl = element.props.highlight or nil
    M.render_text(buf, ns, position.row, position.col, {{text, hl}})
    return
  end

  if element.type == "box" then
    M.render_box(element, buf, ns, position)
    return
  end

  for _, child in ipairs(element.children or {}) do
    M.render(child, buf, ns, position)
  end
end

---Render a box element with border
---@param element JnvuiElement
---@param buf number buffer number
---@param ns number namespace id
---@param pos JnvuiPosition starting position
function M.render_box(element, buf, ns, pos)
  local width = element.props.width or 10
  local height = element.props.height or 3
  local border = element.props.border or "single"

  local top = "┌" .. string.rep("─", width - 2) .. "┐"
  local mid = "│" .. string.rep(" ", width - 2) .. "│"
  local bot = "└" .. string.rep("─", width - 2) .. "┘"

  M.render_text(buf, ns, pos.row, pos.col, {{top, "FloatBorder"}})
  for i = 1, height - 2 do
    M.render_text(buf, ns, pos.row + i, pos.col, {{mid, "FloatBorder"}})
  end
  M.render_text(buf, ns, pos.row + height - 1, pos.col, {{bot, "FloatBorder"}})
end

return M
