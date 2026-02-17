-- Scratch buffer management
local M = {}

local scratch_buf = nil
local scratch_win = nil

function M.get_scratch_buf()
  return scratch_buf
end

function M.is_scratch_focused()
  if not scratch_buf or not vim.api.nvim_buf_is_valid(scratch_buf) then
    return false
  end
  local current_buf = vim.api.nvim_get_current_buf()
  return current_buf == scratch_buf
end

function M.create_scratch()
  -- Create new buffer
  scratch_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(scratch_buf, 'scratch://')

  -- Set buffer options
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = scratch_buf })
  vim.api.nvim_set_option_value('filetype', 'text', { buf = scratch_buf })

  -- Create split window
  vim.cmd('split')
  scratch_win = vim.api.nvim_get_current_win()

  -- Open scratch buffer in the split window
  vim.api.nvim_set_current_buf(scratch_buf)
end

function M.toggle_scratch()
  -- If scratch buffer doesn't exist, create it
  if not scratch_buf or not vim.api.nvim_buf_is_valid(scratch_buf) then
    M.create_scratch()
    vim.notify('Scratch buffer opened', vim.log.levels.INFO)
    return
  end

  -- If scratch is focused, send content to terminal and close
  if M.is_scratch_focused() then
    M.send_and_close()
  else
    -- Otherwise just focus the scratch buffer
    vim.api.nvim_set_current_buf(scratch_buf)
  end
end

function M.send_and_close()
  if not scratch_buf or not vim.api.nvim_buf_is_valid(scratch_buf) then
    vim.notify('No scratch buffer', vim.log.levels.WARN)
    return
  end

  -- Get content
  local lines = vim.api.nvim_buf_get_lines(scratch_buf, 0, -1, false)
  local content = table.concat(lines, '\n')

  if content == '' then
    vim.notify('Scratch buffer is empty', vim.log.levels.WARN)
    return
  end

  -- Find terminal buffer
  local terminal_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match('term://') then
      terminal_buf = buf
      break
    end
  end

  if not terminal_buf then
    vim.notify('No terminal buffer found', vim.log.levels.WARN)
    return
  end

  -- Send content to terminal
  vim.api.nvim_chan_send(vim.bo[terminal_buf].channel, content .. '\n')
  vim.notify('Sent to terminal', vim.log.levels.INFO)

  -- Switch to terminal buffer
  vim.api.nvim_set_current_buf(terminal_buf)

  -- Close scratch buffer
  vim.api.nvim_buf_delete(scratch_buf, { force = true })
  scratch_buf = nil
  scratch_win = nil
end

return M
