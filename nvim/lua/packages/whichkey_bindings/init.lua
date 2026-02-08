local M = {}

-- Get all registered whichkey bindings
function M.find_bindings()
  local wk = require('which-key')
  
  -- Get the registered mappings
  local mappings = {}
  
  -- Collect all mappings from which-key internal data
  local spec_index = wk.get_spec()
  if spec_index then
    for _, item in ipairs(spec_index) do
      if item[1] and item[2] then
        local key = item[1]
        local desc = item[3] and item[3].desc or 'No description'
        table.insert(mappings, key .. ' -> ' .. desc)
      end
    end
  end
  
  if #mappings == 0 then
    vim.notify('No whichkey bindings found', vim.log.levels.WARN)
    return
  end
  
  -- Sort mappings
  table.sort(mappings)
  
  -- Show with fzf
  require('fzf-lua').fzf_exec(mappings, {
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
