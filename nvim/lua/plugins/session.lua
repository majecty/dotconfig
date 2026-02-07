-- Minimal native Neovim session management
-- Global session directory: ~/.config/nvim/sessions/
-- Session naming: project-name-md5hash.vim (MD5 hash of full project path)

local session_dir = vim.fn.expand("~/.local/share/nvim/sessions")
local project_dir_file = session_dir .. "/.project_paths"

-- Create sessions directory if it doesn't exist
if vim.fn.isdirectory(session_dir) == 0 then
	vim.fn.mkdir(session_dir, "p")
end

-- Helper function to compute MD5 hash of a string
local function md5_hash(str)
	return vim.fn.system("echo -n '" .. str:gsub("'", "'\\''") .. "' | md5sum | cut -d' ' -f1"):gsub("\n", "")
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
				path = current,
			}
		end
		current = vim.fn.fnamemodify(current, ":h")
	end

	-- Fallback to current directory
	return {
		name = vim.fn.fnamemodify(cwd, ":t"),
		path = cwd,
	}
end

-- Helper function to generate session filename from project info
local function get_session_filename(project_info)
	local hash = md5_hash(project_info.path):sub(1, 8) -- Use first 8 chars of MD5
	return project_info.name .. "-" .. hash
end

-- Helper function to store project path mapping
local function store_project_path(session_name, project_path)
	local lines = {}
	if vim.fn.filereadable(project_dir_file) == 1 then
		lines = vim.fn.readfile(project_dir_file)
	end

	-- Check if entry already exists and update it
	local found = false
	for i, line in ipairs(lines) do
		if line:match("^" .. session_name .. "|") then
			lines[i] = session_name .. "|" .. project_path
			found = true
			break
		end
	end

	-- Add new entry if not found
	if not found then
		table.insert(lines, session_name .. "|" .. project_path)
	end

	vim.fn.writefile(lines, project_dir_file)
end

-- Helper function to get project path from mapping
local function get_project_path(session_name)
	if vim.fn.filereadable(project_dir_file) == 1 then
		local lines = vim.fn.readfile(project_dir_file)
		for _, line in ipairs(lines) do
			local name, path = line:match("^(.+)|(.+)$")
			if name == session_name then
				return path
			end
		end
	end
	return nil
end

-- Helper function to list all saved sessions with display names
local function list_sessions()
	local sessions = {}
	local handle = vim.loop.fs_scandir(session_dir)
	if handle then
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then
				break
			end
			if type == "file" and name:match("%.vim$") then
				-- Remove .vim extension
				local session_name = name:gsub("%.vim$", "")
				if session_name ~= ".project_paths" then
					table.insert(sessions, session_name)
				end
			end
		end
	end
	table.sort(sessions)
	return sessions
end

-- Helper function to load session from path
local function load_session_from_file(session_filename, display_name)
	local session_path = session_dir .. "/" .. session_filename .. ".vim"

	if vim.fn.filereadable(session_path) == 1 then
		-- Get project path from mapping
		local project_path = get_project_path(session_filename)

		-- Try to change to project directory
		if project_path and vim.fn.isdirectory(project_path) == 1 then
			vim.cmd("cd " .. project_path)
			vim.notify("Changed directory to: " .. project_path, vim.log.levels.INFO)
		end

		vim.cmd("source " .. session_path)
		vim.notify("Session loaded: " .. display_name, vim.log.levels.INFO)
	else
		vim.notify("Session not found: " .. display_name, vim.log.levels.WARN)
	end
end

-- Main session management functions
local function save_session()
	local project_info = get_project_info()
	local session_filename = get_session_filename(project_info)
	local session_path = session_dir .. "/" .. session_filename .. ".vim"

	-- Save the session
	vim.cmd("mksession! " .. session_path)

	-- Store project path mapping
	store_project_path(session_filename, project_info.path)

	vim.notify("Session saved: " .. project_info.name, vim.log.levels.INFO)
end

local function load_session_with_picker()
	local sessions = list_sessions()

	if #sessions == 0 then
		vim.notify("No sessions found", vim.log.levels.WARN)
		return
	end

	-- Use vim.ui.select which now defaults to fzf-lua
	vim.ui.select(sessions, { prompt = "Sessions> " }, function(choice)
		if choice then
			load_session_from_file(choice, choice)
		end
	end)
end

local function load_session()
	local project_info = get_project_info()
	local session_filename = get_session_filename(project_info)
	local session_path = session_dir .. "/" .. session_filename .. ".vim"

	if vim.fn.filereadable(session_path) == 1 then
		load_session_from_file(session_filename, project_info.name)
	else
		vim.notify("No session found for: " .. project_info.name, vim.log.levels.WARN)
	end
end

-- Auto-save session silently (no notifications)
local function auto_save_session_silent()
	local project_info = get_project_info()
	local session_filename = get_session_filename(project_info)
	local session_path = session_dir .. "/" .. session_filename .. ".vim"

	-- Save the session silently
	vim.cmd("mksession! " .. session_path)

	-- Store project path mapping
	store_project_path(session_filename, project_info.path)
end

-- Auto-load session on startup if it exists
local function auto_load_session()
	local project_info = get_project_info()
	local session_filename = get_session_filename(project_info)
	local session_path = session_dir .. "/" .. session_filename .. ".vim"
	if vim.fn.filereadable(session_path) == 1 then
		vim.cmd("source " .. session_path)
	end
end

-- Setup auto-save on VimLeavePre and FocusLost events
local function setup_auto_save()
	local group = vim.api.nvim_create_augroup("NvimSessionAutoSave", { clear = true })

	-- Auto-save on VimLeavePre (when exiting nvim)
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			auto_save_session_silent()
		end,
	})

	-- Auto-save on FocusLost (when switching away from nvim)
	vim.api.nvim_create_autocmd("FocusLost", {
		group = group,
		callback = function()
			auto_save_session_silent()
		end,
	})
end

-- Initialize auto-save on plugin load
setup_auto_save()

-- Auto-load session on startup if it exists (silently)
local function setup_auto_load()
	local group = vim.api.nvim_create_augroup("NvimSessionAutoLoad", { clear = true })

	-- Auto-load on VimEnter (when opening nvim)
	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		callback = function()
			-- Only auto-load if in a git directory
			local project_info = get_project_info()
			-- Check if we actually found a .git directory
			if vim.fn.isdirectory(project_info.path .. "/.git") == 1 then
				local session_filename = get_session_filename(project_info)
				local session_path = session_dir .. "/" .. session_filename .. ".vim"
				if vim.fn.filereadable(session_path) == 1 then
					vim.cmd("source " .. session_path)
				end
			end
		end,
		once = true, -- Only run once on startup
	})
end

setup_auto_load()

-- Expose functions for which-key
_G.nvim_session = {
	save = save_session,
	load = load_session,
	load_picker = load_session_with_picker,
	auto_load = auto_load_session,
	auto_save_silent = auto_save_session_silent,
	list = list_sessions,
	dir = session_dir,
	get_project_info = get_project_info,
}

return {}
