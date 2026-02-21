local M = {}

function M.edit_code_block(lang)
  lang = lang or "lua"

  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local in_block = false
  local start_line = 0
  local block_lines = {}
  local block_lang = nil

  for i, line in ipairs(lines) do
    local lang_match = line:match("^```(%w+)")
    local end_match = line:match("^```$")

    if lang_match then
      if not in_block and (not lang or lang_match == lang) then
        in_block = true
        start_line = i
        block_lang = lang_match
      end
    elseif end_match and in_block then
      in_block = false
      if cursor[1] >= start_line and cursor[1] <= i then
        block_lines = {}
        for j = start_line + 1, i - 1 do
          table.insert(block_lines, lines[j])
        end
        break
      end
    end
  end

  if #block_lines == 0 then
    vim.notify("No code block found at cursor", vim.log.levels.WARN)
    return
  end

  local new_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, block_lines)
  vim.api.nvim_buf_set_option(new_buf, "filetype", block_lang or lang)

  vim.cmd("split")
  vim.api.nvim_win_set_buf(0, new_buf)

  if block_lang == "lua" then
    vim.cmd("LazyDev")
  end
end

vim.api.nvim_create_user_command("EditCodeBlock", function(opts)
  M.edit_code_block(opts.args)
end, { nargs = "?" })

function M.extract_all_code_blocks()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  local md_filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t:r")
  local lua_filename = md_filename .. ".lua"
  
  local block_lines = {}
  local in_block = false
  
  for _, line in ipairs(lines) do
    local lang_match = line:match("^```(%w+)")
    local end_match = line:match("^```$")
    
    if lang_match then
      if not in_block then
        in_block = true
      end
    elseif end_match and in_block then
      in_block = false
      table.insert(block_lines, "")
    elseif in_block then
      table.insert(block_lines, line)
    end
  end
  
  if #block_lines == 0 then
    vim.notify("No code blocks found", vim.log.levels.WARN)
    return
  end
  
  vim.cmd("split " .. lua_filename)
  local new_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, block_lines)
  vim.api.nvim_buf_set_option(new_buf, "filetype", "lua")
  
  vim.cmd("LazyDev")
end

vim.api.nvim_create_user_command("ExtractCodeBlocks", function()
  M.extract_all_code_blocks()
end, {})

return M