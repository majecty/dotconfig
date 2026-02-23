local M = {}

local hydra_active = false
local hint_buf = nil
local hint_win = nil
local saved_keymaps = {}
local exit_keys = { '<Esc>', 'q' }
local cleanup_augroup = nil

local function clear_autocmds()
  if cleanup_augroup then
    pcall(vim.api.nvim_del_augroup_by_id, cleanup_augroup)
    cleanup_augroup = nil
  end
end

local function close_hint()
  clear_autocmds()
  if hint_win and vim.api.nvim_win_is_valid(hint_win) then
    vim.api.nvim_win_close(hint_win, true)
    hint_win = nil
  end
  if hint_buf and vim.api.nvim_buf_is_valid(hint_buf) then
    vim.api.nvim_buf_delete(hint_buf, { force = true })
    hint_buf = nil
  end
end

local function restore_keymaps()
  for lhs, data in pairs(saved_keymaps) do
    if data then
      if data.rhs then
        vim.keymap.set('n', lhs, data.rhs, data.opts or { silent = true })
      else
        pcall(vim.keymap.del, 'n', lhs)
      end
    end
  end
  saved_keymaps = {}
end

local function exit_hydra()
  if not hydra_active then
    return
  end
  hydra_active = false
  close_hint()
  restore_keymaps()
  vim.notify('Hydra exited', vim.log.levels.INFO)
end

local function show_hint(hint_lines)
  close_hint()
  hint_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(hint_buf, 0, -1, false, hint_lines)
  vim.api.nvim_buf_set_option(hint_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(hint_buf, 'filetype', 'hydra_hint')

  local width = 0
  for _, line in ipairs(hint_lines) do
    if #line > width then
      width = #line
    end
  end

  local height = #hint_lines
  local row = vim.o.lines - height - 3
  local col = vim.o.columns - width - 2

  hint_win = vim.api.nvim_open_win(hint_buf, false, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    zindex = 200,
  })
  vim.api.nvim_win_set_option(hint_win, 'winhl', 'Normal:FloatTitle')

  cleanup_augroup = vim.api.nvim_create_augroup('HydraCleanup', { clear = true })
  vim.api.nvim_create_autocmd('WinClosed', {
    group = cleanup_augroup,
    pattern = tostring(hint_win),
    callback = function()
      hint_win = nil
      if hydra_active then
        exit_hydra()
      end
    end,
    once = true,
  })
  vim.api.nvim_create_autocmd('BufWinLeave', {
    group = cleanup_augroup,
    buffer = hint_buf,
    callback = function()
      hint_buf = nil
      if hydra_active then
        exit_hydra()
      end
    end,
    once = true,
  })
end

local function enter_hydra(opts)
  if hydra_active then
    return
  end

  hydra_active = true
  saved_keymaps = {}

  for _, key in ipairs(exit_keys) do
    local existing = vim.fn.maparg(key, 'n', false, true)
    saved_keymaps[key] = { rhs = existing.rhs, opts = existing }
    vim.keymap.set('n', key, exit_hydra, { buffer = false, silent = true, desc = 'Exit hydra' })
  end

  for lhs, rhs in pairs(opts.mode) do
    local existing = vim.fn.maparg(lhs, 'n', false, true)
    saved_keymaps[lhs] = { rhs = existing.rhs, opts = existing }
    local rhs_func = type(rhs) == 'function' and rhs or function()
      vim.cmd(rhs)
    end
    vim.keymap.set('n', lhs, function()
      rhs_func()
    end, { buffer = false, silent = true })
  end

  show_hint(opts.hint)
  vim.notify('Hydra: ' .. (opts.name or 'active'), vim.log.levels.INFO)
end

function M.create(opts)
  return function()
    enter_hydra(opts)
  end
end

function M.setup() end

return M
