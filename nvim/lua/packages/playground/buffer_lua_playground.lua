--- Buffer Lua Playground: Write Lua code to learn buffers
--- Interactive environment with buffer-focused API examples and templates

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
    '║         BUFFER LUA PLAYGROUND - Learn Buffers               ║',
    '╚══════════════════════════════════════════════════════════════╝',
    '',
    '📝 Write Lua code to explore buffers! Press <C-x> to execute.',
    '',
    '📚 BUFFER CONCEPTS:',
    '',
    '  Buffers hold text content in memory',
    '  Multiple windows can show the same buffer',
    '  Buffers can be modified, deleted, listed/unlisted',
    '  File content is loaded into a buffer',
    '',
    '🔍 KEY FUNCTIONS:',
    '',
    '  vim.api.nvim_list_bufs()              - All buffer IDs',
    '  vim.api.nvim_buf_is_valid(buf)        - Check if valid',
    '  vim.api.nvim_buf_is_loaded(buf)       - Check if loaded',
    '  vim.api.nvim_buf_get_name(buf)        - Get buffer file path',
    '  vim.api.nvim_buf_line_count(buf)      - Number of lines',
    '  vim.api.nvim_buf_get_lines(buf, ...)  - Get buffer content',
    '  vim.api.nvim_buf_set_lines(buf, ...)  - Set buffer content',
    '  vim.api.nvim_buf_get_option(buf, opt) - Get option value',
    '  vim.api.nvim_buf_set_option(buf, opt) - Set option value',
    '  vim.api.nvim_get_current_buf()        - Current buffer ID',
    '  vim.api.nvim_set_current_buf(buf)     - Focus a buffer',
    '  vim.api.nvim_create_buf(listed, scratch) - New buffer',
    '',
    '💡 EXAMPLE PATTERNS:',
    '',
    '  -- List all buffers with info:',
    '  local bufs = vim.api.nvim_list_bufs()',
    '  for _, buf in ipairs(bufs) do',
    '    if vim.api.nvim_buf_is_valid(buf) then',
    '      local name = vim.api.nvim_buf_get_name(buf)',
    '      print("Buffer " .. buf .. ": " .. name)',
    '    end',
    '  end',
    '',
    '  -- Create and modify a buffer:',
    '  local buf = vim.api.nvim_create_buf(true, false)',
    '  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"line 1", "line 2"})',
    '',
    '🎯 TRY THIS:',
    '',
    '  1. List all current buffers',
    '  2. Create a new buffer',
    '  3. Add content to it',
    '  4. Switch to it and check line count',
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
    '-- List all buffers',
    'local bufs = vim.api.nvim_list_bufs()',
    'print("Total buffers: " .. #bufs)',
    '',
    'for _, buf in ipairs(bufs) do',
    '  if vim.api.nvim_buf_is_valid(buf) then',
    '    local name = vim.api.nvim_buf_get_name(buf)',
    '    local lines = vim.api.nvim_buf_line_count(buf)',
    '    print(string.format("Buf %d: %s (%d lines)", buf, name, lines))',
    '  end',
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

  print('💾 Buffer Lua Playground started! Press Ctrl+x to execute code')
  print('Type :q to exit')
end

return M
