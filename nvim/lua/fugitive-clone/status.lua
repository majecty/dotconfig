local M = {}

function M.show_status()
  vim.notify("Showing Git status")

  local async = require("fugitive-clone.async")
  async.exec(function()
    vim.notify("1")
    async.sleep(100) -- Simulate a delay for fetching Git status
    vim.notify("2")
    async.sleep(100) -- Simulate a delay for processing Git status
    vim.notify("3")

    local five = async.exec(function()
      async.sleep(100)
      vim.notify("4")
      return 5
    end)
    vim.notify("" .. five)
    vim.notify("6")
    return nil
  end)

  -- local buf_id = vim.api.nvim_create_buf(false, true)
  -- Here you would implement the logic to display the Git status
  -- For example, you could use vim.fn.system to call 'git status' and display the output
end

return M;
