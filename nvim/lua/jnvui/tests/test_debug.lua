-- jnvui/tests/test_debug.lua
-- Test debug utilities

local jnvui = require("jnvui")

print("Test: Testing debug utilities...")

-- Create a sample element tree
local tree = jnvui.c.box({width = 30, height = 5},
  jnvui.c.text({content = "Title", highlight = "Title"}),
  jnvui.c.row({spacing = 2},
    jnvui.c.button({label = "OK"}),
    jnvui.c.button({label = "Cancel"})
  ),
  jnvui.c.input({placeholder = "Enter text..."})
)

print("\n1. print_tree() output:")
print(string.rep("-", 40))
jnvui.debug.print_tree(tree)
print(string.rep("-", 40))

print("\n2. tree_to_string() output:")
local tree_str = jnvui.debug.tree_to_string(tree)
print(tree_str)

print("\n3. inspect() output:")
local info = jnvui.debug.inspect(tree)
print(vim.inspect(info))

print("\n4. Testing with nil:")
jnvui.debug.print_tree(nil)

print("\n✓ All debug functions working!")
