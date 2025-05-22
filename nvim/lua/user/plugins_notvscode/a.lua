return {
  {
      'fzf',
      dir = '~/.fzf',
      build = './install --all',
      config = function()
        -- help
        vim.keymap.set('n', '<leader>h', ':Help<CR>', { desc = "Help" })
      end,
},
  {
      'junegunn/fzf.vim',
  },
  { 'tpope/vim-fugitive', },
}
