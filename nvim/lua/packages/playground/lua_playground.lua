--- Lua Playground: Write and execute Lua code directly to learn Neovim API
--- A safe sandbox for experimenting with splits, buffers, windows, and tabs

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
    '║              LUA PLAYGROUND - Write & Execute Code           ║',
    '╚══════════════════════════════════════════════════════════════╝',
    '',
    '📝 HOW TO USE:',
    '',
    '1. Edit the code in the upper buffer (the Lua file)',
    '2. Press <C-x> to execute the code',
    '3. Output appears in the bottom buffer (output)',
    '4. Errors also appear in the output buffer',
    '',
    '💡 AVAILABLE GLOBALS:',
    '',
    '  vim.*                  - Neovim API',
    '  _G.api                 - Shorthand for vim.api',
    '  print(...)             - Print to output',
    '  inspect(obj)           - Pretty print objects',
    '',
    '📚 QUICK EXAMPLES:',
    '',
    '  -- List all windows:',
    '  local wins = vim.api.nvim_list_wins()',
    '  print("Windows: " .. #wins)',
    '',
    '  -- Create a split:',
    '  vim.cmd("split")',
    '',
    '  -- Get current buffer ID:',
    '  local buf = vim.api.nvim_get_current_buf()',
    '  print("Buffer: " .. buf)',
    '',
    '🎯 TOPICS TO EXPLORE:',
    '',
    '  Splits:   nvim_list_wins, nvim_win_get_height/width',
    '  Buffers:  nvim_list_bufs, nvim_buf_get_name',
    '  Tabs:     nvim_list_tabpages, nvim_tabpage_list_wins',
    '  Commands: vim.cmd(), vim.api.nvim_*',
    '',
    '❌ EXIT:',
    '',
    '  Press :qa or :q in the playground',
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
  -- Get code from buffer
  local code_lines = vim.api.nvim_buf_get_lines(code_buf, 0, -1, false)
  local code = table.concat(code_lines, '\n')

  if code:match('^%s*$') then
    return
  end

  -- Capture output
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

  -- Set up safe environment
  local env = setmetatable({
    print = capture_print,
    inspect = vim.inspect,
    api = vim.api,
    cmd = vim.cmd,
    fn = vim.fn,
  }, { __index = _G })

  -- Execute code
  local ok, result = pcall(function()
    local chunk = load(code, 'playground', 't', env)
    if chunk then
      return chunk()
    end
  end)

  -- Show result or error
  if not ok then
    table.insert(output_lines, '❌ ERROR:')
    table.insert(output_lines, tostring(result))
  elseif result ~= nil then
    table.insert(output_lines, '✓ Result: ' .. vim.inspect(result))
  end

  if #output_lines == 0 then
    table.insert(output_lines, '✓ Code executed successfully')
  end

  -- Show timestamp
  table.insert(output_lines, '')
  table.insert(output_lines, '--- ' .. os.date('%H:%M:%S') .. ' ---')
  table.insert(output_lines, '')

  -- Append to output buffer
  local current_lines = vim.api.nvim_buf_get_lines(output_buf, 0, -1, false)
  local new_lines = {}
  for _, line in ipairs(current_lines) do
    table.insert(new_lines, line)
  end
  for _, line in ipairs(output_lines) do
    table.insert(new_lines, line)
  end
  vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, new_lines)

  -- Move to output buffer to see results
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
  -- Create help buffer
  local help_buf = show_help()

  -- Create code buffer
  local code_buf = create_buffer()
  set_buffer_content(code_buf, {
    '-- Write your Lua code here',
    '-- Press Ctrl+x to execute',
    '',
    'local wins = vim.api.nvim_list_wins()',
    'print("Total windows: " .. #wins)',
  })

  -- Create output buffer
  local output_buf = create_output_buffer()

  -- Create layout: help on top, code in middle, output at bottom
  vim.cmd('new')
  vim.api.nvim_set_current_buf(help_buf)
  vim.cmd('resize 35')

  vim.cmd('split')
  vim.api.nvim_set_current_buf(code_buf)
  vim.api.nvim_buf_set_option(code_buf, 'filetype', 'lua')

  vim.cmd('split')
  vim.api.nvim_set_current_buf(output_buf)
  vim.api.nvim_buf_set_option(output_buf, 'filetype', 'lua')

  -- Set up keymaps for code buffer
  vim.keymap.set('n', '<C-x>', function()
    execute_lua_code(code_buf, output_buf)
  end, { buffer = code_buf, silent = true })

  vim.keymap.set('i', '<C-x>', function()
    execute_lua_code(code_buf, output_buf)
  end, { buffer = code_buf, silent = true })

  vim.keymap.set('n', '<C-c>', function()
    clear_output(output_buf)
  end, { buffer = code_buf, silent = true })

  -- Instructions at the bottom
  print('📝 Lua Playground started! Press Ctrl+x to execute code')
  print('Type :q to exit')
end

return M
