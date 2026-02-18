-- Session manager utility functions
local log = require('packages.session_manager.log')

local M = {}

---@type string
local session_dir = vim.fn.expand('~/.local/share/nvim/sessions')

---@type string
local project_dir_file = session_dir .. '/.project_paths'

-- Create sessions directory if it doesn't exist
if vim.fn.isdirectory(session_dir) == 0 then
  vim.fn.mkdir(session_dir, 'p')
end

--- Compute MD5 hash of a string
---@param str string The string to hash
---@return string hash The MD5 hash
function M.md5_hash(str)
  return vim.fn.system("echo -n '" .. str:gsub("'", "'\\''") .. "' | md5sum | cut -d' ' -f1"):gsub('\n', '')
end

--- Find .git directory and get project name and path
---@return {name: string, path: string} Project information
function M.get_project_info()
  local cwd = vim.fn.getcwd()

  -- Look for .git in current directory or parent directories
  local current = cwd
  while current ~= '/' do
    if vim.fn.isdirectory(current .. '/.git') == 1 then
      -- Return both name and path
      return {
        name = vim.fn.fnamemodify(current, ':t'),
        path = current,
      }
    end
    current = vim.fn.fnamemodify(current, ':h')
  end

  -- Fallback to current directory
  return {
    name = vim.fn.fnamemodify(cwd, ':t'),
    path = cwd,
  }
end

--- Generate session filename from project info
---@param project_info {name: string, path: string} Project information
---@return string filename Session filename without extension
function M.get_session_filename(project_info)
  local hash = M.md5_hash(project_info.path):sub(1, 8) -- Use first 8 chars of MD5
  return project_info.name .. '-' .. hash
end

--- Store project path mapping
---@param session_name string Name of the session
---@param project_path string Full path to the project
function M.store_project_path(session_name, project_path)
  local lines = {}
  if vim.fn.filereadable(project_dir_file) == 1 then
    lines = vim.fn.readfile(project_dir_file)
  end

  -- Check if entry already exists and update it
  local found = false
  for i, line in ipairs(lines) do
    if line:match('^' .. session_name .. '|') then
      lines[i] = session_name .. '|' .. project_path
      found = true
      break
    end
  end

  -- Add new entry if not found
  if not found then
    table.insert(lines, session_name .. '|' .. project_path)
  end

  vim.fn.writefile(lines, project_dir_file)
end

--- Get project path from mapping
---@param session_name string Name of the session
---@return string|nil path Project path or nil if not found
function M.get_project_path(session_name)
  if vim.fn.filereadable(project_dir_file) ~= 1 then
    return nil
  end

  local lines = vim.fn.readfile(project_dir_file)
  for _, line in ipairs(lines) do
    local name, path = line:match('^(.+)|(.+)$')
    if name == session_name then
      return path
    end
  end
  return nil
end

--- List all saved sessions with display names
---@return string[] List of session names
function M.list_sessions()
  local sessions = {}
  local handle = vim.loop.fs_scandir(session_dir)
  if handle then
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end
      if type == 'file' and name:match('%.vim$') then
        -- Remove .vim extension
        local session_name = name:gsub('%.vim$', '')
        if session_name ~= '.project_paths' then
          table.insert(sessions, session_name)
        end
      end
    end
  end
  table.sort(sessions)
  return sessions
end

M.session_dir = session_dir
---@type string
M.project_dir_file = project_dir_file

return M
