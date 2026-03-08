
local async = require("fugitive-clone.async2")
async.exec(function()
  vim.notify("1")
  async.sleep(100) -- Simulate a delay for fetching Git status
  vim.notify("2")
  async.sleep(100) -- Simulate a delay for processing Git status
  vim.notify("3")

  local five = async.exec(function()
    async.sleep(1000)
    vim.notify("4")
    async.sleep(1000)
    vim.notify("4.5")
    return 5
  end)
  vim.notify("" .. five)
  vim.notify("6")
  return nil
end)

