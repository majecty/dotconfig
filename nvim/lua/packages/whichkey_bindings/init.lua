local M = {}

function M.find_bindings()
  require('fzf-lua').keymaps()
end

return M
