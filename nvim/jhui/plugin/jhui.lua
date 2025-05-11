
local group = vim.api.nvim_create_augroup('jhui', {})

local function au(event, callback)
  vim.api.nvim_create_autocmd(event, { group = group, callback = callback })
end

---@module 'jhui'
local jhui = setmetatable({}, {
  __index = function(_, name)
    return function()
      require('jhui')[name]()
    end
  end
})

-- au('InsertEnter' , jhui.onInsertEnter)
-- au('InsertLeave' , jhui.onInsertLeave)
-- au('TextChangedI', jhui.onTextChangedI)
-- au('TextChanged' , jhui.onTextChanged)

-- The user may move between buffers in insert mode
-- (for example, with the mouse), so handle this appropriately.
au('BufEnter', jhui.onBufEnter)
-- au('BufLeave', jhui.onBufLeave)