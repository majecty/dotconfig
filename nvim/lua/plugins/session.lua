-- Minimal native Neovim session management
-- No plugins - uses built-in :mksession
-- Session name is auto-detected from directory containing .git

local session_dir = vim.fn.expand("~/.config/nvim/sessions")

-- Create sessions directory if it doesn't exist
if vim.fn.isdirectory(session_dir) == 0 then
  vim.fn.mkdir(session_dir, "p")
end

-- Helper function to find .git directory and get project name
local function get_project_name()
  local cwd = vim.fn.getcwd()
  
  -- Look for .git in current directory or parent directories
  local current = cwd
  while current ~= "/" do
    if vim.fn.isdirectory(current .. "/.git") == 1 then
      -- Return the directory name
      return vim.fn.fnamemodify(current, ":t")
    end
    current = vim.fn.fnamemodify(current, ":h")
  end
  
  -- Fallback to current directory name if no .git found
  return vim.fn.fnamemodify(cwd, ":t")
end

-- Helper functions
local function get_session_path(name)
  return session_dir .. "/" .. name .. ".vim"
end

local function save_session(name)
  local session_name = name or get_project_name()
  local path = get_session_path(session_name)
  vim.cmd("mksession! " .. path)
  vim.notify("Session saved: " .. session_name, vim.log.levels.INFO)
end

local function load_session(name)
  local session_name = name or get_project_name()
  local path = get_session_path(session_name)
  if vim.fn.filereadable(path) == 1 then
    vim.cmd("source " .. path)
    vim.notify("Session loaded: " .. session_name, vim.log.levels.INFO)
  else
    vim.notify("Session not found: " .. session_name, vim.log.levels.WARN)
  end
end

-- Auto-load session on startup if it exists
local function auto_load_session()
  local project_name = get_project_name()
  local path = get_session_path(project_name)
  if vim.fn.filereadable(path) == 1 then
    vim.cmd("source " .. path)
  end
end

-- Expose functions for which-key
_G.nvim_session = {
  save = save_session,
  load = load_session,
  auto_load = auto_load_session,
  dir = session_dir,
  get_project_name = get_project_name,
}

return {}
