-- nvim-cmp source for [[wiki-link]] completion
---@class WikiCmpSource
local source = {}

---Create a new source instance.
---@return WikiCmpSource
function source.new()
  return setmetatable({}, { __index = source })
end

---@return boolean
function source:is_available()
  return vim.bo.filetype == 'markdown'
end

---@return string[]
function source:get_trigger_characters()
  return { '[' }
end

---Collect markdown page names from the wiki docs directories.
---@param replace_start integer 0-indexed LSP character position after "[["
---@param replace_end integer 0-indexed LSP character position at cursor
---@param row integer 0-indexed LSP line number
---@return table[]
local function collect_items(replace_start, replace_end, row)
  local cmp = require('cmp')
  local docs_dir = vim.fn.expand('~/jhconfig/docs')
  local dirs = {
    docs_dir .. '/daily',
    docs_dir .. '/notes',
    docs_dir .. '/wiki',
    docs_dir,
  }

  local seen = {}
  local items = {}

  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      local files = vim.fn.globpath(dir, '*.md', false, true)
      for _, path in ipairs(files) do
        local name = vim.fn.fnamemodify(path, ':t:r')
        if not seen[name] then
          seen[name] = true
          table.insert(items, {
            label = name,
            kind = cmp.lsp.CompletionItemKind.Reference,
            textEdit = {
              newText = name .. ']]',
              range = {
                start = { line = row, character = replace_start },
                ['end'] = { line = row, character = replace_end },
              },
            },
          })
        end
      end
    end
  end

  table.sort(items, function(a, b)
    return a.label < b.label
  end)

  return items
end

---@param params table
---@param callback fun(response: { items: table[], isIncomplete: boolean })
function source:complete(params, callback)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col)
  local link_start = before:match('.*()%[%[')

  if not link_start then
    return callback({ items = {}, isIncomplete = false })
  end

  local replace_start = link_start + 1 -- 0-indexed position after "[["
  local replace_end = col -- 0-indexed cursor position

  callback({
    items = collect_items(replace_start, replace_end, row - 1),
    isIncomplete = false,
  })
end

return source
