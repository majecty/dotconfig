-- Tmux attach command
local tmux = require('packages.session_manager.tmux')

local M = {}

function M.tmux_attach_cmd()
  tmux.tmux_attach()
end

return M
