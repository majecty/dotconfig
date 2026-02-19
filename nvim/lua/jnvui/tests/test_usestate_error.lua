-- jnvui/tests/test_usestate_error.lua
-- Test useState error handling outside component

local jnvui = require("jnvui")

print("Test: Testing useState outside component...")

local state, setState = jnvui.useState(0)

if state == nil and setState == nil then
  print("✓ useState outside component handled correctly")
else
  print("✗ Expected nil but got state:", vim.inspect(state))
end
