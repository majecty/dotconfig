-- Load session with picker command
local load = require('packages.session_manager.load')

local M = {}

function M.load_session_picker_cmd()
  load.load_session_with_picker()
end

return M
