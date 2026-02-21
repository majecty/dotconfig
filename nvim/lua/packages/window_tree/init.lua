local M = {}
local hydra = require('packages.hydra')

function M.swap_windows(dir)
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. dir)
  local target_win = vim.api.nvim_get_current_win()

  if cur_win == target_win then
    return
  end

  local cur_buf = vim.api.nvim_win_get_buf(cur_win)
  local target_buf = vim.api.nvim_win_get_buf(target_win)
  local cur_cursor = vim.api.nvim_win_get_cursor(cur_win)
  local target_cursor = vim.api.nvim_win_get_cursor(target_win)

  vim.api.nvim_win_set_buf(cur_win, target_buf)
  vim.api.nvim_win_set_buf(target_win, cur_buf)
  vim.api.nvim_win_set_cursor(cur_win, target_cursor)
  vim.api.nvim_win_set_cursor(target_win, cur_cursor)
  vim.api.nvim_set_current_win(target_win)
end

function M.organize()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local num_wins = #wins

  if num_wins <= 1 then
    return
  end

  local buffers = {}
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local cursor = vim.api.nvim_win_get_cursor(win)
    table.insert(buffers, { buf = buf, cursor = cursor })
  end

  for i = #wins, 2, -1 do
    pcall(vim.api.nvim_win_close, wins[i], true)
  end

  local function create_tree(n, depth)
    if n <= 1 then
      return
    end

    local half = math.floor(n / 2)
    local left_count = half
    local right_count = n - half

    local cur_win = vim.api.nvim_get_current_win()

    if depth % 2 == 0 then
      vim.cmd('vsplit')
    else
      vim.cmd('split')
    end

    local new_win = vim.api.nvim_get_current_win()

    vim.api.nvim_set_current_win(cur_win)
    create_tree(left_count, depth + 1)

    vim.api.nvim_set_current_win(new_win)
    create_tree(right_count, depth + 1)
  end

  local main_win = vim.api.nvim_get_current_win()
  create_tree(num_wins, 0)

  vim.defer_fn(function()
    local new_wins = vim.api.nvim_tabpage_list_wins(0)
    for i, win in ipairs(new_wins) do
      if buffers[i] then
        vim.api.nvim_win_set_buf(win, buffers[i].buf)
        pcall(vim.api.nvim_win_set_cursor, win, buffers[i].cursor)
      end
    end
    vim.cmd('wincmd =')
  end, 10)
end

function M.mirror()
  local current_win = vim.api.nvim_get_current_win()

  local function find_parent_branch(layout, target_win, parent)
    if layout[1] == 'leaf' then
      if layout[2] == target_win then
        return parent
      end
      return nil
    end

    for _, child in ipairs(layout[2]) do
      local result = find_parent_branch(child, target_win, layout)
      if result then
        return result
      end
    end
    return nil
  end

  local function get_leaf_windows(layout)
    local leaves = {}
    if layout[1] == 'leaf' then
      table.insert(leaves, layout[2])
    else
      for _, child in ipairs(layout[2]) do
        local child_leaves = get_leaf_windows(child)
        for _, leaf in ipairs(child_leaves) do
          table.insert(leaves, leaf)
        end
      end
    end
    return leaves
  end

  local layout = vim.fn.winlayout()
  print('Layout: ' .. vim.inspect(layout))

  local parent_branch = find_parent_branch(layout, current_win, nil)
  print('Parent: ' .. vim.inspect(parent_branch))

  if not parent_branch or parent_branch[1] == 'leaf' then
    print('No parent branch found')
    return
  end

  local sibling_wins = get_leaf_windows(parent_branch)
  local num_siblings = #sibling_wins
  print('Siblings: ' .. num_siblings .. ' - ' .. vim.inspect(sibling_wins))

  if num_siblings <= 1 then
    print('Only one sibling')
    return
  end

  local buffers = {}
  for _, win in ipairs(sibling_wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local cursor = vim.api.nvim_win_get_cursor(win)
    table.insert(buffers, { win = win, buf = buf, cursor = cursor })
  end

  local is_row = parent_branch[1] == 'row'
  local first_win = sibling_wins[1]

  for i = #sibling_wins, 2, -1 do
    if sibling_wins[i] ~= first_win then
      pcall(vim.api.nvim_win_close, sibling_wins[i], true)
    end
  end

  vim.api.nvim_set_current_win(first_win)

  local new_wins = {}
  table.insert(new_wins, first_win)

  for i = 2, num_siblings do
    if is_row then
      vim.cmd('split')
    else
      vim.cmd('vsplit')
    end
    table.insert(new_wins, vim.api.nvim_get_current_win())
  end

  for i, win in ipairs(new_wins) do
    if buffers[i] then
      vim.api.nvim_win_set_buf(win, buffers[i].buf)
      pcall(vim.api.nvim_win_set_cursor, win, buffers[i].cursor)
    end
  end

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
