--- Window Playground: Interactive exploration of window/viewport concepts
--- Letter-based menu to understand tabs, windows, and how they relate to buffers

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
    '',
    '╔═════════════════════════════════════════════════════════╗',
    '║         WINDOW PLAYGROUND - Learn Tabs & Windows       ║',
    '╚═════════════════════════════════════════════════════════╝',
    '',
    '📚 TABS - Independent window layouts:',
    '',
    '  [t] Create new tab',
    '  [j] Next tab',
    '  [k] Previous tab',
    '  [n] Go to tab by number',
    '',
    '📊 INSPECT:',
    '',
    '  [l] List all tabs and windows',
    '  [i] Show current tab/window info',
    '',
    '🎯 MANIPULATE:',
    '',
    '  [m] Move current window to new tab',
    '  [c] Close current tab',
    '  [w] Resize current window',
    '',
    '❌ WHEN DONE:',
    '',
    '  [q] Exit playground',
    '',
    '📖 CONCEPTS:',
    '  - Each tab is independent window layout',
    '  - Tab visible shows multiple windows/buffers',
    '  - Windows share space, buffers show content',
    '',
  }
  set_buffer_content(buf, menu)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function show_tab_window_layout()
  local tabs = vim.api.nvim_list_tabpages()
  local lines = {
    '╔═════════════════════════════════════════╗',
    '║      Tab and Window Layout               ║',
    '╚═════════════════════════════════════════╝',
    '',
    string.format('Total tabs: %d', #tabs),
    '',
  }

  for t, tab in ipairs(tabs) do
    local wins = vim.api.nvim_tabpage_list_wins(tab)
    local is_current = tab == vim.api.get_current_tabpage()

    table.insert(lines, string.format('Tab %d%s:', t, is_current and ' ◄ CURRENT' or ''))

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
          is_current_win and ' ◄' or '',
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

local function show_explanation(title, lines)
  local buf = create_buffer()
  local content = {
    '',
    '╔═════════════════════════════════════════╗',
    '║ ' .. title .. string.rep(' ', 38 - #title) .. '║',
    '╚═════════════════════════════════════════╝',
    '',
  }

  for _, line in ipairs(lines) do
    table.insert(content, line)
  end

  set_buffer_content(buf, content)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  vim.cmd('botright split')
  vim.api.nvim_set_current_buf(buf)
  vim.cmd('resize 12')
end

local function handle_input(input)
  local cmd = input:lower():gsub('%s+', '')

  if cmd == 't' then
    vim.cmd('tabnew')
    show_explanation('New Tab Created', {
      'A new tab was created.',
      '',
      'Each tab has independent layout.',
    })
  elseif cmd == 'l' then
    local layout_buf = show_tab_window_layout()
    vim.cmd('botright split')
    vim.api.nvim_set_current_buf(layout_buf)
    vim.cmd('resize 25')
  elseif cmd == 'i' then
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

    show_explanation('Current Info', {
      string.format('Tab: %d', tab_idx),
      string.format('Window ID: %d', current_win),
      string.format('Buffer ID: %d (%s)', current_buf, buf_name == '' and '[No Name]' or buf_name),
      string.format('Position: (%d,%d), Size: %dx%d', row, col, width, height),
    })
  elseif cmd == 'j' then
    vim.cmd('tabnext')
    show_explanation('Next Tab', {
      'You moved to next tab.',
    })
  elseif cmd == 'k' then
    vim.cmd('tabprevious')
    show_explanation('Previous Tab', {
      'You moved to previous tab.',
    })
  elseif cmd == 'n' then
    local ok, tab_num = pcall(vim.fn.input, 'Go to tab number: ')
    if ok and tab_num ~= '' then
      local num = tonumber(tab_num)
      if num then
        vim.cmd(string.format('tabnext %d', num))
        show_explanation('Tab Switch', {
          string.format('Switched to tab %d', num),
        })
      end
    end
  elseif cmd == 'm' then
    vim.cmd('wincmd T')
    show_explanation('Window to Tab', {
      'Current window moved to new tab.',
      '',
      'Original tab layout changed.',
    })
  elseif cmd == 'c' then
    vim.cmd('tabclose')
    show_explanation('Tab Closed', {
      'Current tab was closed.',
    })
  elseif cmd == 'w' then
    local ok1, width_str = pcall(vim.fn.input, 'Width (or max): ')
    if ok1 and width_str ~= '' then
      if width_str == 'max' then
        vim.cmd('wincmd |')
        show_explanation('Maximized', {
          'Window maximized horizontally.',
        })
      else
        local w = tonumber(width_str)
        if w then
          vim.api.nvim_win_set_width(0, w)
          show_explanation('Resized', {
            string.format('Width set to %d', w),
          })
        end
      end
    end
  elseif cmd == 'q' then
    return false
  else
    show_explanation('Unknown Command', {
      'Command not recognized: ' .. input,
      '',
      'Check the menu for valid commands.',
    })
  end

  return true
end

function M.start()
  local menu_buf = display_menu()

  vim.cmd('new')
  vim.api.nvim_set_current_buf(menu_buf)

  local continue = true
  while continue do
    local ok, input = pcall(vim.fn.input, 'Command: ')
    if ok and input ~= '' then
      continue = handle_input(input)
    elseif not ok then
      continue = false
    end
  end

  -- Clean up
  if vim.api.nvim_buf_is_valid(menu_buf) then
    vim.api.nvim_buf_delete(menu_buf, { force = true })
  end
  vim.cmd('qa!')
end

return M
