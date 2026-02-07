-- Minimal native Neovim session management
-- No plugins - uses built-in :mksession
-- Session name is auto-detected from directory containing .git

local session_dir = vim.fn.expand("~/.config/nvim/sessions")

-- Create sessions directory if it doesn't exist
if vim.fn.isdirectory(session_dir) == 0 then
  vim.fn.mkdir(session_dir, "p")
end

-- Helper function to find .git directory and get project name and path
local function get_project_info()
  local cwd = vim.fn.getcwd()
  
  -- Look for .git in current directory or parent directories
  local current = cwd
  while current ~= "/" do
    if vim.fn.isdirectory(current .. "/.git") == 1 then
      -- Return both name and path
      return {
        name = vim.fn.fnamemodify(current, ":t"),
        path = current
      }
    end
    current = vim.fn.fnamemodify(current, ":h")
  end
  
  -- Fallback to current directory
  return {
    name = vim.fn.fnamemodify(cwd, ":t"),
    path = cwd
  }
end

-- Helper function to list all saved sessions
local function list_sessions()
  local sessions = {}
  local handle = vim.loop.fs_scandir(session_dir)
  if handle then
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then break end
      if type == "file" and name:match("%.vim$") then
        -- Remove .vim extension
        table.insert(sessions, name:gsub("%.vim$", ""))
      end
    end
  end
  table.sort(sessions)
  return sessions
end

-- Helper function to load session from path
local function load_session_from_path(session_path, session_name)
  if vim.fn.filereadable(session_path) == 1 then
    -- Extract project path from session file (read first few lines for comments)
    local lines = vim.fn.readfile(session_path, "", 5)
    local project_path = nil
    
    -- Try to find project root by looking for .git in common locations
    -- Or just use session_name to guess project directory
    for dir in vim.fn.glob(vim.fn.expand("~") .. "/*", 1, 1) do
      if vim.fn.isdirectory(dir) == 1 and vim.fn.fnamemodify(dir, ":t") == session_name then
        project_path = dir
        break
      end
    end
    
    if project_path then
      vim.cmd("cd " .. project_path)
    end
    
    vim.cmd("source " .. session_path)
    vim.notify("Session loaded: " .. session_name, vim.log.levels.INFO)
  else
    vim.notify("Session not found: " .. session_name, vim.log.levels.WARN)
  end
end

-- Helper functions
local function get_session_path(name)
  return session_dir .. "/" .. name .. ".vim"
end

local function save_session(name)
  local project_info = get_project_info()
  local session_name = name or project_info.name
  local path = get_session_path(session_name)
  vim.cmd("mksession! " .. path)
  vim.notify("Session saved: " .. session_name, vim.log.levels.INFO)
end

local function load_session_with_picker()
  local sessions = list_sessions()
  
  if #sessions == 0 then
    vim.notify("No sessions found", vim.log.levels.WARN)
    return
  end
  
  vim.ui.select(sessions, { prompt = "Select session to load: " }, function(choice)
    if choice then
      local session_path = get_session_path(choice)
      load_session_from_path(session_path, choice)
    end
  end)
end

local function load_session(name)
  local project_info = get_project_info()
  local session_name = name or project_info.name
  local path = get_session_path(session_name)
  load_session_from_path(path, session_name)
end

-- Auto-load session on startup if it exists
local function auto_load_session()
  local project_info = get_project_info()
  local path = get_session_path(project_info.name)
  if vim.fn.filereadable(path) == 1 then
    vim.cmd("source " .. path)
  end
end

-- Expose functions for which-key
_G.nvim_session = {
  save = save_session,
  load = load_session,
  load_picker = load_session_with_picker,
  auto_load = auto_load_session,
  list = list_sessions,
  dir = session_dir,
  get_project_info = get_project_info,
}

return {}
