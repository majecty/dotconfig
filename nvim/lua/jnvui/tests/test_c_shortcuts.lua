-- jnvui/tests/test_c_shortcuts.lua
-- Test jnvui.c shortcuts

local jnvui = require("jnvui")

print("Test: Testing jnvui.c shortcuts...")

-- Test text
local text_elem = jnvui.c.text({content = "Hello", highlight = "Title"})
print("✓ jnvui.c.text created")
print("  - Type:", text_elem.type)
print("  - Content:", text_elem.props.content)

-- Test box with children
local box_elem = jnvui.c.box({width = 20, height = 5},
  jnvui.c.text({content = "Child 1"}),
  jnvui.c.text({content = "Child 2"})
)
print("\n✓ jnvui.c.box created")
print("  - Type:", box_elem.type)
print("  - Children:", #box_elem.children)

-- Test button
local btn_elem = jnvui.c.button({label = "Click me"})
print("\n✓ jnvui.c.button created")
print("  - Type:", btn_elem.type)

-- Test input
local input_elem = jnvui.c.input({placeholder = "Type here"})
print("\n✓ jnvui.c.input created")
print("  - Type:", input_elem.type)

-- Test row
local row_elem = jnvui.c.row({}, jnvui.c.text({content = "A"}), jnvui.c.text({content = "B"}))
print("\n✓ jnvui.c.row created")
print("  - Type:", row_elem.type)
print("  - Children:", #row_elem.children)

-- Test column
local col_elem = jnvui.c.column({}, jnvui.c.text({content = "1"}), jnvui.c.text({content = "2"}))
print("\n✓ jnvui.c.column created")
print("  - Type:", col_elem.type)
print("  - Children:", #col_elem.children)

print("\n✓ All shortcuts working!")
