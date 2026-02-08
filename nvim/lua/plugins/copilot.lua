return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      -- Disable default tab completion, use explicit keybind instead
      vim.g.copilot_no_tab_map = true
    end,
  },
}
