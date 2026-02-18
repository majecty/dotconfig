-- Minimal Lua executor for markdown code blocks
-- Execute entire lua code block with Enter key
-- Maintains persistent state across blocks
-- Displays output in separate window

---@class LuaExecutor
---@field execute_block fun(): nil Execute the lua code block at cursor position
---@field setup fun(): nil Setup commands and keymaps
---@field get_context fun(): table Get the current execution context
---@field clear_context fun(): nil Clear the execution context
local M = {}

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

---@type table<string, any> Shared state across all executions
-- Shared state across all executions
local execution_context = {}

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

---Execute lua code and capture output
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

  execution_context.print = custom_print
  setmetatable(execution_context, { __index = _G })
  setfenv(func, execution_context)

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
function M.setup()
  log.info('lua-executor setup called')
  vim.api.nvim_create_user_command('LuaExecute', function()
    M.execute_block()
  end, { desc = 'Execute current lua code block' })

  -- Setup keymap for markdown files
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
      vim.keymap.set('n', '<CR>', function()
        M.execute_block()
      end, { buffer = true, noremap = true, silent = true, desc = 'Execute lua block' })
    end,
  })
end

---Get execution context for debugging/inspection
---@return table execution_context The current execution context table
function M.get_context()
  return execution_context
end

---Clear the execution context
function M.clear_context()
  execution_context = {}
  log.info('Execution context cleared')
end

return M
