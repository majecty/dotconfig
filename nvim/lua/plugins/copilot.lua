return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.keymap.set('i', '<C-K>', 'copilot#GetDisplayedSuggestion().is_empty ? "" : copilot#Next()', {
        expr = true,
        silent = true,
      })
      vim.g.copilot_no_tab_map = true
    end,
  },
}
