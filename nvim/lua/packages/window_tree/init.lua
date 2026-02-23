local M = {}
local hydra = require('packages.hydra')

local j = require('jhutil')

function M.swap_windows(dir)
  local cur_window = j.w.current()
  vim.cmd('wincmd ' .. dir)
  local target_window = j.w.current()

  if cur_window == target_window then
    return
  end

  local cur_buffer = cur_window:get_buffer()
  local target_buffer = target_window:get_buffer()
  local cur_cursor = cur_window:get_cursor()
  local target_cursor = target_window:get_cursor()

  cur_window:set_buffer(target_buffer)
  target_window:set_buffer(cur_buffer)
  cur_window:set_cursor(target_cursor)
  target_window:set_cursor(cur_cursor)
  target_window:focus()
end

function M.organize()
  local windows = j.t.current():get_windows()
  local num_windows = #windows

  if num_windows <= 1 then
    return
  end

  ---@type table<integer, { buffer: Buffer, cursor: Cursor }>
  local buffers = {}
  for _, win in ipairs(windows) do
    local buffer = win:get_buffer()
    local cursor = win:get_cursor()
    table.insert(buffers, {
      buffer = buffer,
      cursor = cursor,
    })
  end

  for i = #windows, 2, -1 do
    pcall(windows[i].close, windows[i], { force = true })
  end

  local function create_tree(n, depth)
    if n <= 1 then
      return
    end

    local left_count = 1
    local right_count = n - left_count

    local cur_win = j.w.current()

    if depth % 2 == 0 then
      vim.cmd('vsplit')
    else
      vim.cmd('split')
    end

    local new_win = j.w.current()

    cur_win:focus()
    create_tree(left_count, depth + 1)

    new_win:focus()
    create_tree(right_count, depth + 1)
  end

  create_tree(num_windows, 0)

  vim.defer_fn(function()
    local new_windows = j.t.current():get_windows()
    for i, win in ipairs(new_windows) do
      if buffers[i] then
        local buffer = buffers[i].buffer
        local cursor = buffers[i].cursor
        win:set_buffer(buffer)
        pcall(win.set_cursor, win, cursor)
      end
    end
    vim.cmd('wincmd =')
  end, 10)

end

function M.mirror()
  local current_win = j.w.current()
  -- local current_win = vim.api.nvim_get_current_win()

  ---@param layout j.tab.layout.ret
  ---@param target_win Window
  ---@param parent j.tab.layout.ret|nil
  local function find_parent_branch(layout, target_win, parent)
    if layout[1] == 'leaf' then
      local win_id = layout[2]
      ---@cast win_id integer
      if win_id == target_win.id then
        return parent
      end
      return nil
    end

    if #layout[2] == 0 then
      return nil
    end

    local children = layout[2]
    ---@cast children (vim.fn.winlayout.branch|vim.fn.winlayout.leaf)[]

    for _, child in ipairs(children) do
      local result = find_parent_branch(child, target_win, layout)
      if result then
        return result
      end
    end
    return nil
  end

  local layout = j.t.current():layout()
  vim.notify('Layout: ' .. vim.inspect(layout), vim.log.levels.INFO, { title = 'Mirror' })

  local parent_branch = find_parent_branch(layout, current_win, nil)
  vim.notify('Parent: ' .. vim.inspect(parent_branch), vim.log.levels.INFO, { title = 'Mirror' })

  if not parent_branch or parent_branch[1] == 'leaf' then
    vim.notify('No parent branch found', vim.log.levels.WARN, { title = 'Mirror' })
    return
  end

  parent_branch[1] = parent_branch[1] == 'col' and 'row' or 'col'

  vim.notify('Modified Layout: ' .. vim.inspect(layout), vim.log.levels.INFO, { title = 'Mirror' })

  ---reset windows to follow layout
  ---@param layout_ j.tab.layout.ret
  local function fill_buffers(layout_)
    if layout_[1] == 'leaf' then
      local win_id = layout_[2]
      local window = j.w.from_id(win_id)
      layout_["window"] = window
      layout_["buffer"] = window:get_buffer()
      return
    end

    local children = layout_[2]
    ---@cast children (vim.fn.winlayout.branch|vim.fn.winlayout.leaf)[]

    for _, child in ipairs(children) do
      fill_buffers(child)
    end
  end

  fill_buffers(layout)

  local windows = j.t.current():get_windows()
  for i = #windows, 2, -1 do
    local window = windows[i]
    pcall(window.close, window, { force = true })
  end


  local function apply_buffers(layout_)
    if layout_[1] == 'leaf' then
      -- local win = layout_["window"]
      local buf = layout_["buffer"]
      j.w.current():set_buffer(buf)
      return
    end

    local rowcol = layout_[1]
    local children = layout_[2]
    ---@cast children (vim.fn.winlayout.branch|vim.fn.winlayout.leaf)[]

    for i, child in ipairs(children) do
      if i > 1 then
        if rowcol == 'col' then
          vim.cmd('split')
        else
          vim.cmd('vsplit')
        end
      end

      apply_buffers(child)
    end
  end

  apply_buffers(layout)

  vim.cmd('wincmd =')
end

function M.setup()
  hydra.setup()

  local window_hydra = hydra.create({
    name = 'Window Swap',
    hint = {
      'Window Swap Mode',
      'h/j/k/l: swap with neighbor',
      'C-h/j/k/l: move to window',
      's: swap split direction',
      '<Esc>/q: exit',
    },
    mode = {
      ['h'] = function()
        M.swap_windows('h')
      end,
      ['j'] = function()
        M.swap_windows('j')
      end,
      ['k'] = function()
        M.swap_windows('k')
      end,
      ['l'] = function()
        M.swap_windows('l')
      end,
      ['a'] = function()
        print('Hello from Hydra!')
      end,
      ['s'] = function()
        M.mirror()
      end,
      ['o'] = function()
        M.organize()
      end,
      ['<C-h>'] = function()
        vim.cmd('wincmd h')
      end,
      ['<C-j>'] = function()
        vim.cmd('wincmd j')
      end,
      ['<C-k>'] = function()
        vim.cmd('wincmd k')
      end,
      ['<C-l>'] = function()
        vim.cmd('wincmd l')
      end,
    },
  })

  vim.keymap.set('n', '<leader>ws', window_hydra, { desc = 'Window swap hydra' })
end

return M
