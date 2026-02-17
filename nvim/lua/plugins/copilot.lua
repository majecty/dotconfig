return {
  {
    'github/copilot.vim',
    lazy = 'VeryLazy',
    config = function()
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.keymap.set('i', '<C-K>', 'copilot#Suggest()', {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_no_tab_map = true
    end,
  },
}
