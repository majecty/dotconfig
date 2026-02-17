-- Neovide restart command
local terminal = require('packages.session_manager.terminal')

local M = {}

function M.neovide_restart_cmd()
  terminal.neovide_restart()
end

return M
