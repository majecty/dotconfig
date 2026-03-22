
local async = require("fugitive-clone.async2")
async.exec(function()
  vim.notify("Starting async test")
  local x = async.exec(function()
    async.sleep(100)
    error("This is a test error")
  end)

  vim.notify("This should not be printed: " .. tostring(x))
end)
