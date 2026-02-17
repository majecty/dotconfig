--- Split Lua Playground: Write Lua code to learn splits and viewports
--- Interactive environment with split-focused API examples and templates

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
    '║         SPLIT LUA PLAYGROUND - Learn Splits & Viewports     ║',
    '╚══════════════════════════════════════════════════════════════╝',
    '',
    '📝 Write Lua code to explore splits! Press <C-x> to execute.',
    '',
    '📚 SPLIT CONCEPTS:',
    '',
    '  Splits divide the viewport into multiple windows',
    '  Each window shows content (buffer) independently',
    '  Windows share the screen space',
    '',
    '🔍 KEY FUNCTIONS:',
    '',
    '  vim.api.nvim_list_wins()           - Get all window IDs',
    '  vim.api.nvim_win_get_height(win)   - Window height in lines',
    '  vim.api.nvim_win_get_width(win)    - Window width in cols',
    '  vim.api.nvim_win_get_position(win) - (row, col) position',
    '  vim.api.nvim_get_current_win()     - Current window ID',
    '  vim.api.nvim_set_current_win(win)  - Focus a window',
    '  vim.cmd("split")                   - Create horizontal split',
    '  vim.cmd("vsplit")                  - Create vertical split',
    '  vim.cmd("wincmd =")                - Equalize split sizes',
    '',
    '💡 EXAMPLE PATTERNS:',
    '',
    '  -- Create splits and show layout:',
    '  vim.cmd("split")',
    '  vim.cmd("vsplit")',
    '  local wins = vim.api.nvim_list_wins()',
    '  print("Windows: " .. #wins)',
    '',
    '  -- Inspect current window:',
    '  local w = vim.api.nvim_get_current_win()',
    '  print("Height: " .. vim.api.nvim_win_get_height(w))',
    '  print("Width: " .. vim.api.nvim_win_get_width(w))',
    '',
    '🎯 TRY THIS:',
    '',
    '  1. Create a split with code (replace example below)',
    '  2. Check the number of windows',
    '  3. Print their dimensions',
    '  4. Close splits and try again',
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
    '-- Create a split and inspect it',
    'vim.cmd("split")',
    '',
    'local wins = vim.api.nvim_list_wins()',
    'print("Total windows: " .. #wins)',
    '',
    'for i, win in ipairs(wins) do',
    '  local h = vim.api.nvim_win_get_height(win)',
    '  local w = vim.api.nvim_win_get_width(win)',
    '  print(string.format("Win %d: %dx%d", i, w, h))',
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

  print('🖥️  Split Lua Playground started! Press Ctrl+x to execute code')
  print('Type :q to exit')
end

return M
