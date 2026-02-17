--- Buffer Playground: Interactive exploration of buffer concepts
--- Letter-based menu to learn about buffer creation and management

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
    '║           BUFFER PLAYGROUND - Learn Buffers            ║',
    '╚═════════════════════════════════════════════════════════╝',
    '',
    '📚 CREATE BUFFERS:',
    '',
    '  [n] Create new buffer',
    '  [f] Create named buffer',
    '  [s] Create sample buffer with text',
    '',
    '📊 INSPECT:',
    '',
    '  [l] List all buffers',
    '  [i] Show current buffer info',
    '',
    '🎯 MANIPULATE:',
    '',
    '  [d] Mark current buffer as dirty',
    '  [c] Clear buffer content',
    '  [a] Add sample text',
    '',
    '🚪 NAVIGATION:',
    '',
    '  [j] Next buffer',
    '  [k] Previous buffer',
    '',
    '🗑️  DELETE:',
    '',
    '  [x] Delete current buffer',
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

local function show_all_buffers()
  local bufs = vim.api.nvim_list_bufs()
  local lines = {
    '╔═════════════════════════════════════════╗',
    '║            All Buffers                   ║',
    '╚═════════════════════════════════════════╝',
    '',
    string.format('Total: %d buffers', #bufs),
    '',
  }

  for i, buf in ipairs(bufs) do
    local valid = vim.api.nvim_buf_is_valid(buf)
    if valid then
      local name = vim.api.nvim_buf_get_name(buf)
      local loaded = vim.api.nvim_buf_is_loaded(buf)
      local modified = vim.api.nvim_buf_get_option(buf, 'modified')
      local lines_count = vim.api.nvim_buf_line_count(buf)
      local current = buf == vim.api.nvim_get_current_buf()

      table.insert(
        lines,
        string.format(
          'Buf %d%s: %s (L:%s M:%s lines:%d)',
          buf,
          current and ' ◄' or '',
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

  if cmd == 'n' then
    local new_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(new_buf)
    show_explanation('New Buffer Created', {
      string.format('Buffer ID: %d', new_buf),
      '',
      'This is an empty listed buffer.',
      'You can edit it and save to file.',
    })
  elseif cmd == 'f' then
    local ok, name = pcall(vim.fn.input, 'Buffer name: ')
    if ok and name ~= '' then
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_buf_set_name(new_buf, name)
      vim.api.nvim_set_current_buf(new_buf)
      show_explanation('Named Buffer Created', {
        string.format('Name: %s', name),
        string.format('Buffer ID: %d', new_buf),
      })
    end
  elseif cmd == 's' then
    local new_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(new_buf, 'sample')
    local sample = {
      '--- Sample Buffer Content ---',
      '',
      'This is a sample buffer.',
      'You can edit this content.',
      'And learn about buffers!',
    }
    vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, sample)
    vim.api.nvim_set_current_buf(new_buf)
    show_explanation('Sample Buffer', {
      'Sample buffer created with text.',
      '',
      'You can edit and save this!',
    })
  elseif cmd == 'l' then
    local list_buf = show_all_buffers()
    vim.cmd('botright split')
    vim.api.nvim_set_current_buf(list_buf)
    vim.cmd('resize 25')
  elseif cmd == 'i' then
    local current_buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(current_buf)
    local modified = vim.api.nvim_buf_get_option(current_buf, 'modified')
    local lines_count = vim.api.nvim_buf_line_count(current_buf)

    show_explanation('Current Buffer Info', {
      string.format('ID: %d', current_buf),
      string.format('Name: %s', name == '' and '[No Name]' or name),
      string.format('Lines: %d', lines_count),
      string.format('Modified: %s', modified and 'Yes' or 'No'),
    })
  elseif cmd == 'd' then
    vim.api.nvim_buf_set_option(0, 'modified', true)
    show_explanation('Buffer Marked Dirty', {
      'Current buffer marked as modified.',
      '',
      'Vim will prompt to save on exit.',
    })
  elseif cmd == 'c' then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
    show_explanation('Content Cleared', {
      'Buffer content cleared.',
      '',
      'All lines deleted.',
    })
  elseif cmd == 'a' then
    local sample = {
      '--- Sample Content ---',
      '',
      'This is appended text.',
    }
    vim.api.nvim_buf_set_lines(0, -1, -1, false, sample)
    show_explanation('Text Added', {
      'Sample text appended to buffer.',
    })
  elseif cmd == 'j' then
    vim.cmd('bnext')
    show_explanation('Next Buffer', {
      'Switched to next buffer.',
    })
  elseif cmd == 'k' then
    vim.cmd('bprevious')
    show_explanation('Previous Buffer', {
      'Switched to previous buffer.',
    })
  elseif cmd == 'x' then
    local current_buf = vim.api.nvim_get_current_buf()
    vim.cmd('bdelete')
    show_explanation('Buffer Deleted', {
      string.format('Deleted buffer %d', current_buf),
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
