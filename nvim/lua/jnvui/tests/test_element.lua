-- jnvui/tests/test_element.lua
-- Test element creation

local jnvui = require("jnvui")

print("Test: Creating element with jnvui.c...")

local elem = jnvui.c.text({content = "Test"})

print("✓ Element created")
print("  - Type:", elem.type)
print("  - Props:", vim.inspect(elem.props))
print("  - Children count:", #elem.children)

-- Test element with children
local parent = jnvui.c.box({width = 10},
  jnvui.c.text({content = "Child 1"}),
  jnvui.c.text({content = "Child 2"})
)

print("\n✓ Parent element with children")
print("  - Children count:", #parent.children)
