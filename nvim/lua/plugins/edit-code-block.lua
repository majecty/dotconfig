return {
  {
    dir = '~/jhconfig/nvim/lua/packages/edit-code-block',
    name = 'edit-code-block',
    event = 'VeryLazy',
    config = function()
      local edit_code_block = require('packages.edit-code-block')
      if edit_code_block and edit_code_block.setup then
        edit_code_block.setup()
      end
    end,
  },
}
