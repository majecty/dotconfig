--- Playground commands initialization

local M = {}

function M.setup()
  local lua_playground = require('packages.playground.lua_playground')
  local split_lua_playground = require('packages.playground.split_lua_playground')
  local buffer_lua_playground = require('packages.playground.buffer_lua_playground')
  local window_lua_playground = require('packages.playground.window_lua_playground')
  local tab_lua_playground = require('packages.playground.tab_lua_playground')

  vim.api.nvim_create_user_command('LuaPlayground', function()
    lua_playground.start()
  end, { desc = 'Start Lua code playground' })

  vim.api.nvim_create_user_command('SplitLuaPlayground', function()
    split_lua_playground.start()
  end, { desc = 'Start split Lua playground' })

  vim.api.nvim_create_user_command('BufferLuaPlayground', function()
    buffer_lua_playground.start()
  end, { desc = 'Start buffer Lua playground' })

  vim.api.nvim_create_user_command('WindowLuaPlayground', function()
    window_lua_playground.start()
  end, { desc = 'Start window Lua playground' })

  vim.api.nvim_create_user_command('TabLuaPlayground', function()
    tab_lua_playground.start()
  end, { desc = 'Start tab Lua playground' })
end

return M
