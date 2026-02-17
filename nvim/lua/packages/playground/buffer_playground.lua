--- Buffer Playground: Interactive exploration of buffer concepts
--- Learn about buffer creation, switching, and management

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
    '║     BUFFER PLAYGROUND - Main Menu      ║',
    '╚════════════════════════════════════════╝',
    '',
    '1. Create new buffer',
    '2. Create named buffer',
    '3. List all buffers',
    '4. Switch to next buffer',
    '5. Switch to previous buffer',
    '6. Set buffer as modified (dirty)',
    '7. Clear buffer content',
    '8. Add sample text to buffer',
    '9. Delete current buffer',
    '0. Exit playground',
    '',
    'Usage: Type command number and press Enter',
  }
  set_buffer_content(buf, menu)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function show_all_buffers()
  local bufs = vim.api.nvim_list_bufs()
  local lines = {
    'All Buffers:',
    string.format('Total: %d', #bufs),
    '',
  }

  for i, buf in ipairs(bufs) do
    local valid = vim.api.nvim_buf_is_valid(buf)
    if valid then
      local name = vim.api.nvim_buf_get_name(buf)
      local loaded = vim.api.nvim_buf_is_loaded(buf)
      local modified = vim.api.nvim_buf_get_option(buf, 'modified')
      local lines_count = vim.api.nvim_buf_line_count(buf)

      table.insert(
        lines,
        string.format(
          'Buffer %d: %s (loaded:%s modified:%s lines:%d)',
          buf,
          name == '' and '[No Name]' or name,
          loaded and 'Y' or 'N',
          modified and 'Y' or 'N',
          lines_count
        )
      )
    end
  end

  local buf = create_buffer()
  set_buffer_content(buf, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return buf
end

local function handle_input(input)
  local choice = tonumber(input)

  if choice == 1 then
    -- Create new buffer
    local new_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(new_buf)
    print(string.format('Created buffer: %d', new_buf))
  elseif choice == 2 then
    -- Create named buffer
    local ok, name = pcall(vim.fn.input, 'Buffer name: ')
    if ok and name ~= '' then
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_buf_set_name(new_buf, name)
      vim.api.nvim_set_current_buf(new_buf)
      print(string.format('Created named buffer: %s (%d)', name, new_buf))
    end
  elseif choice == 3 then
    -- List all buffers
    local list_buf = show_all_buffers()
    vim.cmd('split')
    vim.api.nvim_set_current_buf(list_buf)
  elseif choice == 4 then
    -- Next buffer
    vim.cmd('bnext')
  elseif choice == 5 then
    -- Previous buffer
    vim.cmd('bprevious')
  elseif choice == 6 then
    -- Set modified
    vim.api.nvim_buf_set_option(0, 'modified', true)
    print('Current buffer marked as modified')
  elseif choice == 7 then
    -- Clear content
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
    print('Buffer content cleared')
  elseif choice == 8 then
    -- Add sample text
    local sample = {
      '--- Sample Buffer Content ---',
      '',
      'This is a sample buffer',
      'You can edit this content',
      'And learn about buffers!',
    }
    vim.api.nvim_buf_set_lines(0, -1, -1, false, sample)
    print('Sample text added')
  elseif choice == 9 then
    -- Delete buffer
    local current_buf = vim.api.nvim_get_current_buf()
    vim.cmd('bdelete')
    print(string.format('Deleted buffer: %d', current_buf))
  elseif choice == 0 then
    -- Exit
    return false
  end

  return true
end

function M.start()
  local menu_buf = create_buffer()
  local menu = display_menu()
  set_buffer_content(menu_buf, vim.api.nvim_buf_get_lines(menu, 0, -1, false))

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
