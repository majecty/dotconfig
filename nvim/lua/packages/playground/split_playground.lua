--- Split Playground: Interactive exploration of split/viewport concepts
--- Letter-based menu to understand how splits work in Neovim

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
    '║            SPLIT PLAYGROUND - Learn Splits             ║',
    '╚═════════════════════════════════════════════════════════╝',
    '',
    '📚 CONCEPTS TO EXPLORE:',
    '',
    '  [h] Create a horizontal split (top/bottom)',
    '  [v] Create a vertical split (left/right)',
    '  [3h] Create 3 horizontal splits',
    '  [3v] Create 3 vertical splits',
    '',
    '📊 INSPECT:',
    '',
    '  [l] List current window layout',
    '  [i] Show window dimensions',
    '',
    '🎯 MANIPULATE:',
    '',
    '  [e] Equalize all split sizes',
    '  [m] Maximize current window',
    '  [c] Close current window',
    '  [n] Move to next window',
    '',
    '🚪 NAVIGATION:',
    '',
    '  [j] Move down',
    '  [k] Move up',
    '  [l] Move right',
    '  [p] Move left',
    '',
    '❌ WHEN DONE:',
    '',
    '  [q] Exit playground',
    '',
  }
  set_buffer_content(buf, menu)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function show_window_layout()
  local wins = vim.api.nvim_list_wins()
  local lines = {
    '╔═════════════════════════════════════════╗',
    '║         Current Window Layout            ║',
    '╚═════════════════════════════════════════╝',
    '',
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
        is_current and ' ◄ CURRENT' or '',
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
  vim.cmd('resize 15')
end

local function handle_input(input)
  local cmd = input:lower():gsub('%s+', '')

  if cmd == 'h' then
    vim.cmd('split')
    show_explanation('Horizontal Split', {
      'You created a horizontal split.',
      '',
      'This divides the viewport top-to-bottom.',
      'Use Ctrl+j/k to move between windows.',
      'Each window is independent.',
    })
  elseif cmd == 'v' then
    vim.cmd('vsplit')
    show_explanation('Vertical Split', {
      'You created a vertical split.',
      '',
      'This divides the viewport left-to-right.',
      'Use Ctrl+h/l to move between windows.',
      'Windows share the vertical space.',
    })
  elseif cmd == '3h' then
    vim.cmd('split')
    vim.cmd('wincmd j')
    vim.cmd('split')
    vim.cmd('wincmd j')
    vim.cmd('split')
    show_explanation('3-Way Horizontal', {
      'You created 3 horizontal splits.',
      '',
      'This creates a stacked layout.',
      'Try: [e] equalize, [m] maximize',
    })
  elseif cmd == '3v' then
    vim.cmd('vsplit')
    vim.cmd('wincmd l')
    vim.cmd('vsplit')
    vim.cmd('wincmd l')
    vim.cmd('vsplit')
    show_explanation('3-Way Vertical', {
      'You created 3 vertical splits.',
      '',
      'This creates a side-by-side layout.',
      'Notice space is divided equally.',
    })
  elseif cmd == 'l' then
    local layout_buf = show_window_layout()
    vim.cmd('botright split')
    vim.api.nvim_set_current_buf(layout_buf)
    vim.cmd('resize 20')
  elseif cmd == 'i' then
    show_explanation('Window Info', {
      'Current window dimensions shown above.',
      '',
      'Position = row,col from top-left',
      'Size = width x height',
    })
  elseif cmd == 'e' then
    vim.cmd('wincmd =')
    show_explanation('Equalize Sizes', {
      'All windows now have equal size.',
      '',
      'Useful for fair space distribution.',
    })
  elseif cmd == 'm' then
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')
    show_explanation('Maximize Window', {
      'Current window is maximized.',
      '',
      'Others still exist but hidden.',
    })
  elseif cmd == 'c' then
    vim.cmd('wincmd c')
    show_explanation('Window Closed', {
      'You closed the current window.',
      '',
      'Try [h] or [v] to create new ones.',
    })
  elseif cmd == 'n' then
    vim.cmd('wincmd w')
    show_explanation('Next Window', {
      'You moved to the next window.',
      '',
      'Windows cycle in creation order.',
    })
  elseif cmd == 'j' then
    vim.cmd('wincmd j')
    show_explanation('Move Down', {
      'You moved to the window below.',
      '',
      'Only works if window below exists.',
    })
  elseif cmd == 'k' then
    vim.cmd('wincmd k')
    show_explanation('Move Up', {
      'You moved to the window above.',
      '',
      'Only works if window above exists.',
    })
  elseif cmd == 'l' then
    vim.cmd('wincmd l')
    show_explanation('Move Right', {
      'You moved to the window right.',
      '',
      'Only works if right window exists.',
    })
  elseif cmd == 'p' then
    vim.cmd('wincmd h')
    show_explanation('Move Left', {
      'You moved to the window left.',
      '',
      'Only works if left window exists.',
    })
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
