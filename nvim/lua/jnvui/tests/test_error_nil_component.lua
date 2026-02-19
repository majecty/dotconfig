-- jnvui/tests/test_error_nil_component.lua
-- Test error handling for nil component

local jnvui = require("jnvui")

print("Test: Testing nil component error handling...")

local result = jnvui.mount(nil, 0)

if result == nil then
  print("✓ Nil component handled correctly")
else
  print("✗ Expected nil but got:", vim.inspect(result))
end
