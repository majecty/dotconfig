local function is_empty_buffer()
  return vim.fn.bufname("%") == "" and vim.bo.modified == false
end

local function tab_prev_or_new()
  local current = vim.fn.tabpagenr()
  if current > 1 then
    vim.cmd("tabprevious")
  elseif not is_empty_buffer() then
    vim.cmd("tabnew | setlocal buftype=nofile bufhidden=hide noswapfile")
  end
end

local function tab_next_or_new()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr("$")
  if current < total then
    vim.cmd("tabnext")
  elseif not is_empty_buffer() then
    vim.cmd("tabnew | setlocal buftype=nofile bufhidden=hide noswapfile")
  end
end

return {
  -- H/L keymaps for tab navigation
  {
    "LazyVim/LazyVim",
    keys = {
      { "H", tab_prev_or_new, desc = "Previous tab (or new if none)" },
      { "L", tab_next_or_new, desc = "Next tab (or new if none)" },
    },
  },
}
