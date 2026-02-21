-- Minimal Lua executor for markdown code blocks
-- Execute entire lua code block with Enter key
-- Maintains persistent state across blocks
-- Displays output in separate window or virtual text per line

---@class LuaExecutor
---@field execute_block fun(): nil Execute the lua code block at cursor position
---@field execute_line fun(): nil Execute the current line and show result as virtual text
---@field setup fun(opts?: table): nil Setup commands and keymaps
---@field get_context fun(): table Get the current execution context
---@field clear_context fun(): nil Clear the execution context
local M = {}

local ns_id = vim.api.nvim_create_namespace('lua-executor')

local log = {}
local function make_log(level)
  return function(msg, ...)
    vim.notify(string.format(msg, ...), level)
  end
end
log.info = make_log(vim.log.levels.INFO)
log.warn = make_log(vim.log.levels.WARN)
log.error = make_log(vim.log.levels.ERROR)
log.debug = make_log(vim.log.levels.DEBUG)

---@class ExecutionWindow
---@field win integer|nil Window handle
---@field buf integer|nil Buffer handle

---@type table<integer, table<string, any>> Per-buffer execution context
local buffer_contexts = {}

-- Output window state
---@type integer|nil Output window handle
local output_win = nil
---@type integer|nil Output buffer handle
local output_buf = nil

---Create or focus output window
---@return integer|nil output_win The output window handle
local function ensure_output_window()
  if output_win and vim.api.nvim_win_is_valid(output_win) then
    log.debug('Reusing existing output window')
    return output_win
  end

  if output_buf and vim.api.nvim_buf_is_valid(output_buf) then
    output_buf = nil
  end

  log.info('Creating new output window')

  -- Create new output buffer
  output_buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_option(output_buf, 'filetype', 'lua-output')
  vim.api.nvim_buf_set_option(output_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(output_buf, 'bufhidden', 'hide')

  -- Get current window and create split
  local current_win = vim.api.nvim_get_current_win()
  vim.cmd('botright 20split')
  output_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(output_win, output_buf)

  -- Return to original window
  vim.api.nvim_set_current_win(current_win)

  return output_win
end

---Find lua code block at cursor position
---@return string|nil code The extracted code string
---@return integer|nil start_line The start line of the code block
---@return integer|nil end_line The end line of the code block
local function find_code_block()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- Search backwards for opening ```lua
  local start_line = nil
  for i = current_line, 1, -1 do
    if lines[i]:match('^```lua') then
      start_line = i
      break
    end
  end

  if not start_line then
    vim.notify('No ```lua block found above cursor', vim.log.levels.ERROR)
    return nil
  end

  -- Search forwards for closing ```
  local end_line = nil
  for i = current_line, #lines do
    if i > start_line and lines[i]:match('^```$') then
      end_line = i
      break
    end
  end

  if not end_line then
    vim.notify('No closing ``` found', vim.log.levels.ERROR)
    return nil
  end

  -- Extract code (skip opening ```lua line, skip closing ``` line)
  local code_lines = {}
  for i = start_line + 1, end_line - 1 do
    table.insert(code_lines, lines[i])
  end

  local code = table.concat(code_lines, '\n')
  return code, start_line, end_line
end

---Execute lua code and capture output (fresh environment each time)
---@param code string The lua code to execute
---@return boolean success Whether execution was successful
---@return string output The captured output
---@return string|nil error_msg Error message if execution failed
local function execute_code(code)
  local output_lines = {}

  local function custom_print(...)
    local args = { ... }
    for i, v in ipairs(args) do
      if i > 1 then
        table.insert(output_lines, '\t')
      end
      table.insert(output_lines, tostring(v))
    end
    table.insert(output_lines, '\n')
  end

  local func, load_err = loadstring(code)

  if not func then
    return false, '', 'Syntax Error: ' .. load_err
  end

  local env = { print = custom_print }
  setmetatable(env, { __index = _G })
  setfenv(func, env)

  local ok, result = pcall(func)

  if not ok then
    return false, '', 'Runtime Error: ' .. tostring(result)
  end

  return true, table.concat(output_lines, ''), nil
end

---Display output in output window
---@param code string The executed code
---@param success boolean Whether execution was successful
---@param output string The output string
---@param error_msg string|nil Error message if execution failed
local function display_output(code, success, output, error_msg)
  local output_win_ = ensure_output_window()
  if not output_win_ then
    return
  end

  local buf = vim.api.nvim_win_get_buf(output_win_)
  local lines = {}

  -- Header
  table.insert(lines, '╔' .. string.rep('═', 78) .. '╗')
  table.insert(lines, '║ Lua Execution Output' .. string.rep(' ', 58) .. '║')
  table.insert(lines, '╠' .. string.rep('═', 78) .. '╣')

  -- Code snippet (first 3 lines)
  table.insert(lines, '║ Code:' .. string.rep(' ', 73) .. '║')
  local code_lines = vim.split(code, '\n')
  for i = 1, math.min(3, #code_lines) do
    local line = code_lines[i]
    if #line > 74 then
      line = line:sub(1, 71) .. '...'
    end
    table.insert(lines, '║   ' .. line .. string.rep(' ', 74 - #line) .. '║')
  end
  if #code_lines > 3 then
    table.insert(lines, '║   ...' .. string.rep(' ', 70) .. '║')
  end

  table.insert(lines, '╠' .. string.rep('═', 78) .. '╣')

  -- Result
  if success then
    table.insert(lines, '║ ✓ Success' .. string.rep(' ', 68) .. '║')
    table.insert(lines, '╠' .. string.rep('═', 78) .. '╣')
    if #output > 0 then
      for output_line in output:gmatch('[^\n]+') do
        if #output_line > 74 then
          output_line = output_line:sub(1, 71) .. '...'
        end
        table.insert(lines, '║ ' .. output_line .. string.rep(' ', 76 - #output_line) .. '║')
      end
    else
      table.insert(lines, '║ (no output)' .. string.rep(' ', 65) .. '║')
    end
  else
    table.insert(lines, '║ ✗ Error' .. string.rep(' ', 69) .. '║')
    table.insert(lines, '╠' .. string.rep('═', 78) .. '╣')
    if error_msg then
      for err_line in error_msg:gmatch('[^\n]+') do
        if #err_line > 74 then
          err_line = err_line:sub(1, 71) .. '...'
        end
        table.insert(lines, '║ ' .. err_line .. string.rep(' ', 76 - #err_line) .. '║')
      end
    end
  end

  table.insert(lines, '╚' .. string.rep('═', 78) .. '╝')

  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(output_win_, true)
  end, { buffer = buf, noremap = true, silent = true, desc = 'Close output window' })

  vim.api.nvim_set_current_win(output_win_)
end

local function is_multiline_start(line)
  local trimmed = line:match('^%s*(.*)')
  local keywords = { 'if', 'for', 'while', 'function', 'local', 'do' }
  for _, kw in ipairs(keywords) do
    if trimmed:match('^' .. kw .. '%s*$') or trimmed:match('^' .. kw .. '%s*%(.*%)%s*then') then
      return true
    end
  end
  return false
end

local function transform_local_to_env(code)
  ---@type string[]
  local lines = {}
  for line in code:gmatch('[^\n]+') do
    ---@cast line string
    local changed = line:gsub('^%s*local%s+(%w+)%s*=', '%1 =')
    -- vim.notify('Transformed line: ' .. changed, vim.log.levels.DEBUG)
    table.insert(lines, changed)
  end
  return table.concat(lines, '\n')
end

local function execute_line(code_buf, line_num)
  vim.api.nvim_buf_clear_namespace(code_buf, ns_id, line_num - 1, line_num)

  local lines = vim.api.nvim_buf_get_lines(code_buf, 0, -1, false)
  local line = lines[line_num]

  if is_multiline_start(line) then
    return
  end

  local transformed = transform_local_to_env(line)
  local fn, err = load(transformed)
  if not fn then
    local virt_lines = {}
    if err:match('expected') or err:match('near') or err:match('unfinished') then
      return
    end
    table.insert(virt_lines, { ' ✗ ' .. err, 'LuaExecutorError' })
    vim.api.nvim_buf_set_extmark(code_buf, ns_id, line_num - 1, line_num - 1, {
      virt_text = virt_lines,
      virt_text_pos = 'eol',
      hl_mode = 'combine',
    })
    return
  end

  local output_lines = {}
  local function capture_print(...)
    for _, v in ipairs({ ... }) do
      table.insert(output_lines, tostring(v))
    end
  end

  buffer_contexts[code_buf] = buffer_contexts[code_buf] or {}
  local ctx = buffer_contexts[code_buf]

  ctx.print = capture_print
  ctx.inspect = vim.inspect
  ctx.api = vim.api
  ctx.cmd = vim.cmd
  ctx.fn = vim.fn
  local env = setmetatable(ctx, { __index = _G })
  setfenv(fn, env)

  local ok, result = pcall(fn)
  if not ok then
    local virt_lines = { { ' ✗ ' .. tostring(result), 'LuaExecutorError' } }
    vim.api.nvim_buf_set_extmark(code_buf, ns_id, line_num - 1, 0, {
      virt_text = virt_lines,
      virt_text_pos = 'eol',
      hl_mode = 'combine',
    })
    return
  end

  local virt_lines = {}
  if result ~= nil then
    table.insert(virt_lines, { ' ✓ ' .. vim.inspect(result):sub(1, 50), 'LuaExecutorSuccess' })
  end
  for _, v in ipairs(output_lines) do
    table.insert(virt_lines, { ' → ' .. v, 'LuaExecutorOutput' })
  end
  if #virt_lines == 0 then
    table.insert(virt_lines, { ' ✓ nil', 'LuaExecutorSuccess' })
  end

  vim.api.nvim_buf_set_extmark(code_buf, ns_id, line_num - 1, 0, {
    virt_text = virt_lines,
    virt_text_pos = 'eol',
    hl_mode = 'combine',
  })
end

function M.execute_line()
  local buf = vim.api.nvim_get_current_buf()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  execute_line(buf, line_num)
end

---Main execution function
---Finds and executes the lua code block at cursor position
function M.execute_block()
  local code = find_code_block()
  if not code then
    log.warn('No code block found at cursor position')
    return
  end

  log.info('Executing code block')
  local success, output, error_msg = execute_code(code)
  display_output(code, success, output, error_msg)

  if success then
    log.info('Code executed successfully, output length: %d', #output)
  else
    log.error('Code execution failed: %s', error_msg)
  end
end

---Setup function to be called from config
---Creates user command and markdown file type keymap
function M.setup(opts)
  opts = opts or {}

  log.info('lua-executor setup called')
  vim.api.nvim_create_user_command('LuaExecute', function()
    M.execute_block()
  end, { desc = 'Execute current lua code block' })

  vim.api.nvim_create_user_command('LuaExecuteLine', function()
    M.execute_line()
  end, { desc = 'Execute current line as virtual text' })

  vim.api.nvim_create_user_command('LuaShowVariables', function()
    M.show_variables()
  end, { desc = 'Show all variables in floating window' })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
      vim.keymap.set('n', '<CR>', function()
        M.execute_block()
      end, { buffer = true, noremap = true, silent = true, desc = 'Execute lua block' })
    end,
  })

  vim.api.nvim_set_hl(0, 'LuaExecutorSuccess', { fg = '#a6e3a1' })
  vim.api.nvim_set_hl(0, 'LuaExecutorError', { fg = '#f38ba8' })
  vim.api.nvim_set_hl(0, 'LuaExecutorOutput', { fg = '#89b4fa', italic = true })
end

---Get execution context for debugging/inspection
---@param buf integer|nil Buffer number (defaults to current buffer)
---@return table|nil execution_context The execution context for the buffer
function M.get_context(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return buffer_contexts[buf]
end

---Clear the execution context for a buffer
---@param buf integer|nil Buffer number (defaults to current buffer)
function M.clear_context(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  buffer_contexts[buf] = {}
  log.info('Execution context cleared for buffer %d', buf)
end

---Show all variables in a floating window
---@param buf integer|nil Buffer number (defaults to current buffer)
function M.show_variables(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local ctx = buffer_contexts[buf]

  if not ctx or vim.tbl_isempty(ctx) then
    log.info('No variables defined in this buffer')
    return
  end

  local builtins = { print = true, inspect = true, api = true, cmd = true, fn = true }
  local user_vars = {}
  for k, v in pairs(ctx) do
    if not builtins[k] then
      user_vars[k] = v
    end
  end

  if vim.tbl_isempty(user_vars) then
    log.info('No user variables defined in this buffer')
    return
  end

  local lines = { 'Variables:', '' }
  local sorted_keys = vim.tbl_keys(user_vars)
  table.sort(sorted_keys)

  local max_len = 0
  for _, k in ipairs(sorted_keys) do
    if #k > max_len then
      max_len = #k
    end
  end

  for _, k in ipairs(sorted_keys) do
    local v = user_vars[k]
    local val_str = vim.inspect(v):gsub('\n', ' ')
    if #val_str > 60 then
      val_str = val_str:sub(1, 57) .. '...'
    end
    table.insert(lines, string.format('  %s%s = %s', k, string.rep(' ', max_len - #k), val_str))
  end

  local float_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(float_buf, 'filetype', 'lua-variables')
  vim.api.nvim_buf_set_option(float_buf, 'modifiable', false)

  local width = 0
  for _, l in ipairs(lines) do
    if #l > width then
      width = #l
    end
  end
  width = math.min(width + 2, 80)

  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local float_win = vim.api.nvim_open_win(float_buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = ' Buffer Variables ',
    title_pos = 'center',
  })

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(float_win, true)
  end, { buffer = float_buf, noremap = true, silent = true })

  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(float_win, true)
  end, { buffer = float_buf, noremap = true, silent = true })
end

return M
