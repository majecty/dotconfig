--- Type definitions for session_manager.save module

---@class SessionManagerSave
---@field save_session fun(): nil Save session for current project
---@field auto_save_session_silent fun(): nil Auto-save session silently
---@field setup_auto_save fun(): nil Setup auto-save on VimLeavePre and FocusLost events

return {}
