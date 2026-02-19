-- jnvui/tests/test_mount_unmount.lua
-- Test mount and unmount functionality

local jnvui = require("jnvui")

print("Test: Testing mount to current buffer...")

local TextComponent = jnvui.createComponent("MountTest", function(props)
  return jnvui.element("text", {
    content = props.message or "Mounted!",
    highlight = "Title",
  })
end)

local ok, buf = pcall(vim.api.nvim_get_current_buf)
if not ok then
  print("⚠ Not running in Neovim, skipping test")
  return
end

-- Ensure buffer has at least 1 line
local line_count = vim.api.nvim_buf_line_count(buf)
if line_count == 0 then
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, {""})
end

local instance = jnvui.mount(TextComponent, buf, {message = "jnvui works!"}, {row = 0, col = 0})

if instance then
  print("✓ Mounted successfully")
  print("  - Buffer:", instance.buffer)
  print("  - Namespace:", instance.namespace)
  print("  - Position: row=" .. instance.position.row .. ", col=" .. instance.position.col)
  
  -- Test unmount
  print("\nTest: Testing unmount...")
  jnvui.unmount(instance)
  print("✓ Unmounted successfully")
else
  print("✗ Mount failed")
end
