--- Window Playground: Interactive exploration of window/viewport concepts
--- Understand tabs, windows, and how they relate to buffers

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
    '║     WINDOW PLAYGROUND - Main Menu      ║',
    '╚════════════════════════════════════════╝',
    '',
    '1. Create new tab',
    '2. List all tabs and windows',
    '3. Switch to next tab',
    '4. Switch to previous tab',
    '5. Go to tab by number',
    '6. Move window to new tab',
    '7. Close current tab',
    '8. Show current tab/window info',
    '9. Resize current window',
    '0. Exit playground',
    '',
    'Usage: Type command number and press Enter',
  }
  set_buffer_content(buf, menu)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function show_tab_window_layout()
  local tabs = vim.api.nvim_list_tabpages()
  local lines = {
    'Tab and Window Layout:',
    string.format('Total tabs: %d', #tabs),
    '',
  }

  for t, tab in ipairs(tabs) do
    local wins = vim.api.nvim_tabpage_list_wins(tab)
    local is_current = tab == vim.api.get_current_tabpage()

    table.insert(lines, string.format('Tab %d%s:', t, is_current and ' [CURRENT]' or ''))

    for w, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      local is_current_win = win == vim.api.nvim_get_current_win()
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local width = vim.api.nvim_win_get_width(win)
      local height = vim.api.nvim_win_get_height(win)

      table.insert(
        lines,
        string.format(
          '  Window %d%s: buf:%d %s (%dx%d)',
          w,
          is_current_win and ' [CURRENT]' or '',
          buf,
          buf_name == '' and '[No Name]' or buf_name,
          width,
          height
        )
      )
    end
    table.insert(lines, '')
  end

  local buf = create_buffer()
  set_buffer_content(buf, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function show_current_info()
  local current_tab = vim.api.get_current_tabpage()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()

  local tabs = vim.api.nvim_list_tabpages()
  local tab_idx = 0
  for i, tab in ipairs(tabs) do
    if tab == current_tab then
      tab_idx = i
      break
    end
  end

  local buf_name = vim.api.nvim_buf_get_name(current_buf)
  local width = vim.api.nvim_win_get_width(current_win)
  local height = vim.api.nvim_win_get_height(current_win)
  local row, col = vim.api.nvim_win_get_position(current_win)

  local lines = {
    'Current Window/Tab/Buffer Info:',
    '',
    string.format('Tab: %d (ID: %d)', tab_idx, current_tab),
    string.format('Window ID: %d', current_win),
    string.format('Buffer ID: %d', current_buf),
    string.format('Buffer name: %s', buf_name == '' and '[No Name]' or buf_name),
    '',
    'Window dimensions:',
    string.format('  Position: row %d, col %d', row, col),
    string.format('  Size: %d columns x %d lines', width, height),
  }

  local buf = create_buffer()
  set_buffer_content(buf, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function handle_input(input)
  local choice = tonumber(input)

  if choice == 1 then
    -- Create new tab
    vim.cmd('tabnew')
    print('Created new tab')
  elseif choice == 2 then
    -- List all tabs and windows
    local layout_buf = show_tab_window_layout()
    vim.cmd('split')
    vim.api.nvim_set_current_buf(layout_buf)
  elseif choice == 3 then
    -- Next tab
    vim.cmd('tabnext')
  elseif choice == 4 then
    -- Previous tab
    vim.cmd('tabprevious')
  elseif choice == 5 then
    -- Go to tab by number
    local ok, tab_num = pcall(vim.fn.input, 'Go to tab number: ')
    if ok and tab_num ~= '' then
      local num = tonumber(tab_num)
      if num then
        vim.cmd(string.format('tabnext %d', num))
      end
    end
  elseif choice == 6 then
    -- Move window to new tab
    vim.cmd('wincmd T')
    print('Moved current window to new tab')
  elseif choice == 7 then
    -- Close tab
    vim.cmd('tabclose')
    print('Closed current tab')
  elseif choice == 8 then
    -- Show current info
    local info_buf = show_current_info()
    vim.cmd('split')
    vim.api.nvim_set_current_buf(info_buf)
  elseif choice == 9 then
    -- Resize window
    local ok1, width_str = pcall(vim.fn.input, "Width (or 'max'): ")
    if ok1 and width_str ~= '' then
      if width_str == 'max' then
        vim.cmd('wincmd |')
      else
        local w = tonumber(width_str)
        if w then
          vim.api.nvim_win_set_width(0, w)
        end
      end
    end
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
