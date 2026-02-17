--- Tab Lua Playground: Write Lua code to learn tabs as independent layouts
--- Interactive environment with tab-focused API examples and templates

local M = {}

local function create_buffer()
  local buf = vim.api.nvim_create_buf(false, true)
  return buf
end

local function set_buffer_content(buf, lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function show_help()
  local buf = create_buffer()
  local help = {
    '',
    '╔══════════════════════════════════════════════════════════════╗',
    '║          TAB LUA PLAYGROUND - Learn Tabs                    ║',
    '╚══════════════════════════════════════════════════════════════╝',
    '',
    '📝 Write Lua code to explore tabs! Press <C-x> to execute.',
    '',
    '📚 TAB CONCEPTS:',
    '',
    '  Tabs are completely independent window layouts',
    '  Each tab has its own set of windows and buffers',
    '  Only one tab visible at a time',
    '  Switching tabs shows different layout',
    '  Perfect for organizing different projects/views',
    '',
    '🔍 KEY FUNCTIONS:',
    '',
    '  vim.api.nvim_list_tabpages()          - All tab IDs',
    '  vim.api.get_current_tabpage()         - Current tab ID',
    '  vim.api.set_current_tabpage(tab)      - Focus tab',
    '  vim.api.nvim_tabpage_list_wins(tab)   - Windows in tab',
    '  vim.api.nvim_tabpage_get_number(tab)  - Tab number (1-based)',
    '  vim.cmd("tabnew")                     - Create new tab',
    '  vim.cmd("tabnext")                    - Next tab',
    '  vim.cmd("tabprevious")                - Previous tab',
    '  vim.cmd("tabclose")                   - Close current tab',
    '',
    '💡 EXAMPLE PATTERNS:',
    '',
    '  -- List all tabs and their windows:',
    '  local tabs = vim.api.nvim_list_tabpages()',
    '  for i, tab in ipairs(tabs) do',
    '    local wins = vim.api.nvim_tabpage_list_wins(tab)',
    '    print(string.format("Tab %d: %d windows", i, #wins))',
    '  end',
    '',
    '  -- Get current tab info:',
    '  local tab = vim.api.get_current_tabpage()',
    '  local wins = vim.api.nvim_tabpage_list_wins(tab)',
    '  print("Current tab has " .. #wins .. " windows")',
    '',
    '  -- Create new tab and switch to it:',
    '  vim.cmd("tabnew")',
    '  print("New tab created")',
    '',
    '🎯 TRY THIS:',
    '',
    '  1. List all current tabs',
    '  2. Create a new tab',
    '  3. Create a split in it',
    '  4. List tabs again and see the difference',
    '  5. Switch between tabs',
    '',
  }
  set_buffer_content(buf, help)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function create_output_buffer()
  local buf = create_buffer()
  set_buffer_content(buf, { '-- Output will appear here --', '' })
  return buf
end

local function execute_lua_code(code_buf, output_buf)
  local code_lines = vim.api.nvim_buf_get_lines(code_buf, 0, -1, false)
  local code = table.concat(code_lines, '\n')

  if code:match('^%s*$') then
    return
  end

  local output_lines = {}
  local function capture_print(...)
    local args = { ... }
    local str_args = {}
    for _, arg in ipairs(args) do
      if type(arg) == 'table' then
        table.insert(str_args, vim.inspect(arg))
      else
        table.insert(str_args, tostring(arg))
      end
    end
    table.insert(output_lines, table.concat(str_args, '\t'))
  end

  local env = setmetatable({
    print = capture_print,
    inspect = vim.inspect,
    api = vim.api,
    cmd = vim.cmd,
    fn = vim.fn,
  }, { __index = _G })

  local ok, result = pcall(function()
    local chunk = load(code, 'playground', 't', env)
    if chunk then
      return chunk()
    end
  end)

  if not ok then
    table.insert(output_lines, '❌ ERROR:')
    table.insert(output_lines, tostring(result))
  elseif result ~= nil then
    table.insert(output_lines, '✓ Result: ' .. vim.inspect(result))
  end

  if #output_lines == 0 then
    table.insert(output_lines, '✓ Code executed successfully')
  end

  table.insert(output_lines, '')
  table.insert(output_lines, '--- ' .. os.date('%H:%M:%S') .. ' ---')
  table.insert(output_lines, '')

  local current_lines = vim.api.nvim_buf_get_lines(output_buf, 0, -1, false)
  local new_lines = {}
  for _, line in ipairs(current_lines) do
    table.insert(new_lines, line)
  end
  for _, line in ipairs(output_lines) do
    table.insert(new_lines, line)
  end
  vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, new_lines)

  local output_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == output_buf then
      output_win = win
      break
    end
  end
  if output_win then
    vim.api.nvim_set_current_win(output_win)
    vim.cmd('normal! G')
  end
end

local function clear_output(output_buf)
  set_buffer_content(output_buf, { '-- Output will appear here --', '' })
end

function M.start()
  local help_buf = show_help()
  local code_buf = create_buffer()
  set_buffer_content(code_buf, {
    '-- List all tabs and their windows',
    'local tabs = vim.api.nvim_list_tabpages()',
    'local current_tab = vim.api.get_current_tabpage()',
    '',
    'print("Total tabs: " .. #tabs)',
    'print("")',
    '',
    'for i, tab in ipairs(tabs) do',
    '  local wins = vim.api.nvim_tabpage_list_wins(tab)',
    '  local marker = tab == current_tab and " ◄ CURRENT" or ""',
    '  print(string.format("Tab %d%s: %d windows", i, marker, #wins))',
    'end',
  })

  local output_buf = create_output_buffer()

  vim.cmd('new')
  vim.api.nvim_set_current_buf(help_buf)
  vim.cmd('resize 38')

  vim.cmd('split')
  vim.api.nvim_set_current_buf(code_buf)
  vim.api.nvim_buf_set_option(code_buf, 'filetype', 'lua')

  vim.cmd('split')
  vim.api.nvim_set_current_buf(output_buf)
  vim.api.nvim_buf_set_option(output_buf, 'filetype', 'lua')

  vim.keymap.set('n', '<C-x>', function()
    execute_lua_code(code_buf, output_buf)
  end, { buffer = code_buf, silent = true })

  vim.keymap.set('i', '<C-x>', function()
    execute_lua_code(code_buf, output_buf)
  end, { buffer = code_buf, silent = true })

  vim.keymap.set('n', '<C-c>', function()
    clear_output(output_buf)
  end, { buffer = code_buf, silent = true })

  print('📑 Tab Lua Playground started! Press Ctrl+x to execute code')
  print('Type :q to exit')
end

return M
