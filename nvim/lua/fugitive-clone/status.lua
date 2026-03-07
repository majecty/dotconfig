local M = {}

function M.show_status()
  vim.notify("Showing Git status")
  -- Here you would implement the logic to display the Git status
  -- For example, you could use vim.fn.system to call 'git status' and display the output
end

return M;
