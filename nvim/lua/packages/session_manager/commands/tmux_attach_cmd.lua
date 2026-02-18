-- Tmux attach command
---@type any
local tmux = require('packages.session_manager.tmux')

local M = {}

--- Tmux attach command
function M.tmux_attach_cmd()
  tmux.tmux_attach()
end

return M
