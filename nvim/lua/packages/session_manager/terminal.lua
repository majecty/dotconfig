-- Terminal restart functionality for Neovide
local log = require('packages.session_manager.log')
local save = require('packages.session_manager.save')

local M = {}

--- Restart with neovide
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
