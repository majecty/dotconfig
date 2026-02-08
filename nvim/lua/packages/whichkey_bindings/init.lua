local M = {}

-- Simple mapping list to display
function M.find_bindings()
  local bindings = {
    '<leader>? -> Find whichkey bindings',
    '- -> Open parent directory',
    'gp -> Show oil.nvim path',
    '<leader>ee -> Toggle file tree',
    '<leader>ss -> Save session',
    '<leader>sl -> Load session',
    '<leader>st -> Tmux attach/create session',
    '<leader>sr -> Reload with GUI',
    '<leader>ff -> Find files',
    '<leader>fb -> Find buffers',
    '<C-h> -> Move left',
    '<C-j> -> Move down',
    '<C-k> -> Move up',
    '<C-l> -> Move right',
  }
  
  if #bindings == 0 then
    vim.notify('No whichkey bindings found', vim.log.levels.WARN)
    return
  end
  
  -- Show with fzf
  require('fzf-lua').fzf_exec(bindings, {
    prompt = 'Which-key Bindings> ',
    actions = {
      default = function(selected)
        if selected and selected[1] then
          vim.notify('Binding: ' .. selected[1], vim.log.levels.INFO)
        end
      end,
    },
  })
end

return M
