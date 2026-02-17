return {
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUpdate' },
    build = ':MasonUpdate',
    config = function()
      require('mason').setup()
    end,
  },
}
