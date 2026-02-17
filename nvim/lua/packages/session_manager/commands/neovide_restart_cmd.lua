-- Neovide restart command
local tmux = require('packages.session_manager.tmux')

local M = {}

function M.neovide_restart_cmd()
  tmux.neovide_restart()
end

return M
