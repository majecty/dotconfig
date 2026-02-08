local M = {}

function M.change_sort()
  local sort_methods = {
    'basename',
    'modification_time',
    'type',
  }
  require('fzf-lua').fzf_exec(sort_methods, {
    prompt = 'Oil sort method> ',
    actions = {
      default = function(selected)
        local method = selected[1]
        require('oil').set_sort(method)
        vim.notify('Oil sort changed to: ' .. method, vim.log.levels.INFO)
      end,
    },
  })
end

return M
