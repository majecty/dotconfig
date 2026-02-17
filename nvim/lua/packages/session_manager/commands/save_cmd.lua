-- Save session command
local save = require('packages.session_manager.save')

local M = {}

function M.save_session_cmd()
  save.save_session()
end

return M
