local delete = require('packages.session_manager.delete')

local M = {}

function M.delete_session_picker_cmd()
  delete.delete_session_with_picker()
end

return M