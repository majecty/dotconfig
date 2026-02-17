-- Tmux integration for session manager
local log = require('packages.session_manager.log')
local utils = require('packages.session_manager.utils')
local save = require('packages.session_manager.save')

local M = {}

-- Attach to tmux session
function M.tmux_attach()
  local project_info = utils.get_project_info()
  local session_name = project_info.name

  -- Create tmux session if it doesn't exist
  local cmd = 'tmux has-session -t '
    .. session_name
    .. ' 2>/dev/null || tmux new-session -d -s '
    .. session_name
    .. ' -c '
    .. project_info.path
  os.execute(cmd)

  -- Open terminal at bottom
  vim.cmd('split | terminal tmux attach-session -t ' .. session_name)
  vim.cmd('resize 15')
end

-- Restart with neovide
function M.neovide_restart()
  local cwd = vim.fn.getcwd()
  save.save_session()
  vim.cmd('sleep 100m')
  local cmd = "cd '" .. cwd:gsub("'", "'\\''") .. "' && /home/juhyung/.cargo/bin/neovide > /dev/null 2>&1 &"
  log.info('Starting Neovide: ' .. cmd)
  os.execute(cmd)
  vim.cmd('qa!')
end

return M
