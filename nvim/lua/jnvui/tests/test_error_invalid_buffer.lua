-- jnvui/tests/test_error_invalid_buffer.lua
-- Test error handling for invalid buffer

local jnvui = require("jnvui")

print("Test: Testing invalid buffer error handling...")

local TextComponent = jnvui.createComponent("Test", function(props)
  return jnvui.c.text({content = "Test"})
end)

local result = jnvui.mount(TextComponent, 99999)

if result == nil then
  print("✓ Invalid buffer handled correctly")
else
  print("✗ Expected nil but got:", vim.inspect(result))
end
