-- Save session command
---@type any
local save = require('packages.session_manager.save')

local M = {}

--- Save session command
function M.save_session_cmd()
  save.save_session()
end

return M
