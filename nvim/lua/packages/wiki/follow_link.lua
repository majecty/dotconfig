-- Follow [[wiki-link]] under cursor
---@class WikiFollowLink
local M = {}

local docs_dir = vim.fn.expand('~/jhconfig/docs')

---Resolve a wiki link name to an existing file path or nil
---@param link string
---@return string|nil
local function resolve_link(link)
  -- Strip optional anchor
  local name = link:match('^([^#]+)') or link

  local candidates = {
    docs_dir .. '/daily/' .. name .. '.md',
    docs_dir .. '/notes/' .. name .. '.md',
    docs_dir .. '/wiki/' .. name .. '.md',
    docs_dir .. '/' .. name .. '.md',
  }

  for _, p in ipairs(candidates) do
    if vim.fn.filereadable(p) == 1 then
      return p
    end
  end

  return nil
end

---Follow the [[...]] link under cursor
function M.follow()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- Iterate all [[...]] on the line
  for start_pos, match, end_pos in line:gmatch('()%[%[([^%]]+)%]%]()') do
    if col >= start_pos and col <= end_pos then
      local link = match
      local anchor = ''
      if link:find('#') then
        link, anchor = link:match('^([^#]+)#(.+)$')
      end

      local resolved = resolve_link(link)
      if resolved then
        vim.cmd('edit ' .. vim.fn.fnameescape(resolved))
        if anchor ~= '' then
          vim.fn.search('^#+ .*' .. vim.fn.escape(anchor, '.*~^$[]'), 'w')
        end
        return
      end

      -- Not found: offer to create in notes/
      vim.ui.input({
        prompt = 'Create notes/' .. link .. '.md? (y/n): ',
      }, function(input)
        if input == 'y' then
          local new_path = docs_dir .. '/notes/' .. link .. '.md'
          vim.fn.mkdir(docs_dir .. '/notes', 'p')
          vim.cmd('edit ' .. vim.fn.fnameescape(new_path))
          vim.api.nvim_buf_set_lines(0, 0, -1, false, { '# ' .. link, '' })
          vim.cmd('write')
        end
      end)
      return
    end
  end

  vim.notify('No wiki link under cursor', vim.log.levels.WARN)
end

return M
