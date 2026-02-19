-- jnvui/tests/test_component.lua
-- Test component creation

local jnvui = require("jnvui")

print("Test: Creating component...")

local TextComponent = jnvui.createComponent("TextTest", function(props)
  return jnvui.c.text({
    content = props.message or "Hello",
    highlight = "Title",
  })
end)

print("✓ Component created")
print("  - Name:", TextComponent.name)
print("  - Has render:", type(TextComponent.render) == "function")

return TextComponent
