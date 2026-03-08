local M = {}

function M.show_status()
  vim.notify("Showing Git status")

  local async = require("fugitive-clone.async")
  async.exec(function()
    vim.notify("Fetching Git status...")
    async.sleep(2000) -- Simulate a delay for fetching Git status
    vim.notify("Git status fetched successfully!")
    async.sleep(1000) -- Simulate a delay for processing Git status
    vim.notify("Displaying Git status...")
  end)

  -- local buf_id = vim.api.nvim_create_buf(false, true)
  -- Here you would implement the logic to display the Git status
  -- For example, you could use vim.fn.system to call 'git status' and display the output
end

return M;
