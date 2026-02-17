-- Session manager logger using plenary
return require('plenary.log').new({
  plugin = 'session_manager',
  level = 'debug',
  use_file = true,
  use_console = 'async',
  use_quickfix = false,
}, false)
