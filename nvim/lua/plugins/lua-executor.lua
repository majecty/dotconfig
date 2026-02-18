return {
  {
    "lua-executor",
    config = function()
      local executor = require("packages.lua-executor")
      executor.setup()
    end,
  },
}
