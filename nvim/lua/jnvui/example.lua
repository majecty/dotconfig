-- jnvui example.lua
-- Example usage of jnvui framework

local jnvui = require("jnvui")

-- Create a simple counter component
local Counter = jnvui.createComponent("Counter", function(props)
  local count, setCount = jnvui.useState(props.initialCount or 0)

  return jnvui.element("box", {
    width = 20,
    height = 5,
    border = "single",
  },
    jnvui.element("text", {
      content = "Count: " .. count,
      highlight = "Title",
    }),
    jnvui.element("text", {
      content = "Press + to increment",
      highlight = "Comment",
    })
  )
end)

-- Create a button component
local Button = jnvui.createComponent("Button", function(props)
  return jnvui.element("text", {
    content = "[" .. props.label .. "]",
    highlight = props.highlight or "Keyword",
  })
end)

-- Example: Mount counter in current buffer
function _G.jnvui_demo()
  local buf = vim.api.nvim_get_current_buf()

  local instance = jnvui.mount(Counter, buf, {initialCount = 0}, {row = 5, col = 10})

  vim.keymap.set("n", "+", function()
    -- In real implementation, this would trigger re-render
    vim.notify("Increment clicked!")
  end, {buffer = buf})

  return instance
end

-- Run demo
-- vim.cmd("lua jnvui_demo()")

return {
  Counter = Counter,
  Button = Button,
  demo = _G.jnvui_demo,
}
