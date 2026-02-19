-- jnvui test.lua
-- Minimal test to verify jnvui behavior

local jnvui = require("jnvui")

-- Test 1: Create a simple text component
print("Test 1: Creating text component...")
local TextComponent = jnvui.createComponent("TextTest", function(props)
  return jnvui.element("text", {
    content = props.message or "Hello",
    highlight = "Title",
  })
end)
print("✓ Component created")

-- Test 2: Create element
print("\nTest 2: Creating element...")
local elem = jnvui.element("text", {content = "Test"})
print("✓ Element type:", elem.type)
print("✓ Element props:", vim.inspect(elem.props))

-- Test 3: Error handling - nil component
print("\nTest 3: Testing nil component error handling...")
local result = jnvui.mount(nil, 0)
if result == nil then
  print("✓ Nil component handled correctly")
end

-- Test 4: Error handling - invalid buffer
print("\nTest 4: Testing invalid buffer error handling...")
local result2 = jnvui.mount(TextComponent, 99999)
if result2 == nil then
  print("✓ Invalid buffer handled correctly")
end

-- Test 5: Mount to actual buffer (if in Neovim)
print("\nTest 5: Testing mount to current buffer...")
local ok, buf = pcall(vim.api.nvim_get_current_buf)
if ok then
  -- Ensure buffer has at least 1 line
  local line_count = vim.api.nvim_buf_line_count(buf)
  if line_count == 0 then
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, {""})
  end
  
  local instance = jnvui.mount(TextComponent, buf, {message = "jnvui works!"}, {row = 0, col = 0})
  if instance then
    print("✓ Mounted successfully to buffer", buf)
    print("  - Namespace:", instance.namespace)
    print("  - Position: row=" .. instance.position.row .. ", col=" .. instance.position.col)
    
    -- Test unmount
    print("\nTest 6: Testing unmount...")
    jnvui.unmount(instance)
    print("✓ Unmounted successfully")
  else
    print("✗ Mount failed")
  end
else
  print("⚠ Not running in Neovim, skipping buffer tests")
end

-- Test 7: useState outside component (should error)
print("\nTest 7: Testing useState outside component...")
local state, setState = jnvui.useState(0)
if state == nil then
  print("✓ useState outside component handled correctly")
end

print("\n" .. string.rep("=", 50))
print("All tests completed!")
print(string.rep("=", 50))
