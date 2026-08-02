-- Minimal native wiki/daily note manager
---@class WikiModule
local M = {}

local docs_dir = vim.fn.expand('~/jhconfig/docs')

---Open today's daily note (create from template if missing)
function M.open_today()
  local date = os.date('%Y-%m-%d')
  local path = docs_dir .. '/daily/' .. date .. '.md'

  if vim.fn.filereadable(path) == 0 then
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
    local tmpl_path = docs_dir .. '/templates/daily.md'
    if vim.fn.filereadable(tmpl_path) == 1 then
      local lines = vim.fn.readfile(tmpl_path)
      for i, line in ipairs(lines) do
        lines[i] = line:gsub('{{date}}', date)
      end
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    else
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { '# ' .. date, '', '- ' })
    end
    vim.cmd('write')
  else
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
  end
end

---Find any file under docs/
function M.find_doc()
  local ok, fzf = pcall(require, 'fzf-lua')
  if ok then
    fzf.files({ cwd = docs_dir, prompt = 'Docs> ' })
  else
    vim.cmd('e ' .. vim.fn.fnameescape(docs_dir))
  end
end

---Live grep all docs
function M.grep_docs()
  local ok, fzf = pcall(require, 'fzf-lua')
  if ok then
    fzf.live_grep({ cwd = docs_dir, prompt = 'Grep Docs> ' })
  else
    vim.notify('fzf-lua not available', vim.log.levels.WARN)
  end
end

---Open wiki index
function M.open_index()
  local path = docs_dir .. '/wiki/index.md'
  vim.cmd('edit ' .. vim.fn.fnameescape(path))
end

return M
