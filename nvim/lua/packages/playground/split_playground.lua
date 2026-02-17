--- Split Playground: Interactive exploration of split/viewport concepts
--- Menu-driven commands to understand how splits work in Neovim

local M = {}

local function create_buffer()
  local buf = vim.api.nvim_create_buf(false, true)
  return buf
end

local function set_buffer_content(buf, lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function display_menu()
  local buf = create_buffer()
  local menu = {
    '╔════════════════════════════════════════╗',
    '║     SPLIT PLAYGROUND - Main Menu       ║',
    '╚════════════════════════════════════════╝',
    '',
    '1. Create horizontal split (50/50)',
    '2. Create vertical split (50/50)',
    '3. Create 3-way horizontal split',
    '4. Create 3-way vertical split',
    '5. Show current window layout',
    '6. Equalize all split sizes',
    '7. Maximize current window',
    '8. Close current window',
    '9. Switch to next window',
    '0. Exit playground',
    '',
    'Usage: Type command number and press Enter',
  }
  set_buffer_content(buf, menu)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function show_window_layout()
  local wins = vim.api.nvim_list_wins()
  local lines = {
    'Current Window Layout:',
    string.format('Total windows: %d', #wins),
    '',
  }

  for i, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local row, col = vim.api.nvim_win_get_position(win)
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)
    local is_current = win == vim.api.nvim_get_current_win()

    table.insert(
      lines,
      string.format(
        'Window %d%s: pos(%d,%d) size(%dx%d) buf:%d',
        i,
        is_current and ' [CURRENT]' or '',
        row,
        col,
        width,
        height,
        buf
      )
    )
  end

  local buf = create_buffer()
  set_buffer_content(buf, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function open_in_split(buf, split_type)
  local cmd = split_type == 'h' and 'split' or 'vsplit'
  vim.cmd(cmd)
  vim.api.nvim_set_current_buf(buf)
end

local function handle_input(input)
  local choice = tonumber(input)

  if choice == 1 then
    -- Horizontal split
    vim.cmd('split')
    vim.cmd('wincmd j')
    vim.cmd('split')
  elseif choice == 2 then
    -- Vertical split
    vim.cmd('vsplit')
    vim.cmd('wincmd l')
    vim.cmd('vsplit')
  elseif choice == 3 then
    -- 3-way horizontal
    vim.cmd('split')
    vim.cmd('wincmd j')
    vim.cmd('split')
    vim.cmd('wincmd j')
    vim.cmd('split')
  elseif choice == 4 then
    -- 3-way vertical
    vim.cmd('vsplit')
    vim.cmd('wincmd l')
    vim.cmd('vsplit')
    vim.cmd('wincmd l')
    vim.cmd('vsplit')
  elseif choice == 5 then
    -- Show layout
    local layout_buf = show_window_layout()
    open_in_split(layout_buf, 'h')
  elseif choice == 6 then
    -- Equalize
    vim.cmd('wincmd =')
  elseif choice == 7 then
    -- Maximize
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')
  elseif choice == 8 then
    -- Close window
    vim.cmd('wincmd c')
  elseif choice == 9 then
    -- Next window
    vim.cmd('wincmd w')
  elseif choice == 0 then
    -- Exit
    return false
  end

  return true
end

function M.start()
  local menu_buf = display_menu()

  -- Create window for menu
  vim.cmd('new')
  vim.api.nvim_set_current_buf(menu_buf)

  -- Set up input handling
  local continue = true
  while continue do
    vim.cmd('redraw')
    local ok, input = pcall(vim.fn.input, 'Enter command: ')
    if ok and input ~= '' then
      continue = handle_input(input)
    end
  end

  -- Clean up
  if vim.api.nvim_buf_is_valid(menu_buf) then
    vim.api.nvim_buf_delete(menu_buf, { force = true })
  end
  vim.cmd('quit')
end

return M
