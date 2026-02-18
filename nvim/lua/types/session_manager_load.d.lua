--- Type definitions for session_manager.load module

---@class SessionManagerLoad
---@field load_session_from_file fun(session_filename: string, display_name: string): nil Load session from file
---@field load_session_with_picker fun(): nil Load session with picker
---@field setup_auto_load fun(): nil Setup auto-load session on startup

return {}
