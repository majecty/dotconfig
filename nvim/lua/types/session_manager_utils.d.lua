--- Type definitions for session_manager.utils module

---@class ProjectInfo
---@field name string Project name
---@field path string Project path

---@class SessionManagerUtils
---@field session_dir string Global session directory path
---@field project_dir_file string Project directory file path
---@field md5_hash fun(str: string): string Compute MD5 hash of a string
---@field get_project_info fun(): ProjectInfo Find .git directory and get project info
---@field get_session_filename fun(project_info: ProjectInfo): string Generate session filename
---@field store_project_path fun(session_name: string, project_path: string): nil Store project path mapping
---@field get_project_path fun(session_name: string): string|nil Get project path from mapping
---@field list_sessions fun(): string[] List all saved sessions

return {}
