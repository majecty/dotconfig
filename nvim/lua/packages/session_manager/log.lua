-- Session manager logger using vim.notify
local log = {}

local function make_log(level)
  return function(msg, ...)
    vim.notify(string.format(msg, ...), level)
  end
end

log.trace = make_log(vim.log.levels.TRACE)
log.debug = make_log(vim.log.levels.DEBUG)
log.info = make_log(vim.log.levels.INFO)
log.warn = make_log(vim.log.levels.WARN)
log.error = make_log(vim.log.levels.ERROR)

return log
