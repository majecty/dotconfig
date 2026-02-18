-- Neovide restart command
---@type SessionManagerTerminal
local terminal = require('packages.session_manager.terminal')

local M = {}

--- Neovide restart command
function M.neovide_restart_cmd()
  terminal.neovide_restart()
end

return M
