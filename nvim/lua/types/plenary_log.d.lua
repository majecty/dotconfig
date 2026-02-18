--- Type definitions for plenary.log module
--- This is a type stub file for plenary's logging functionality

---@class PlenaryLogConfig
---@field plugin string Name of the plugin, prepended to log messages
---@field use_console 'sync'|'async'|false Should print output to neovim
---@field highlights boolean Should highlighting be used in console
---@field use_file boolean Should write to a file
---@field outfile string|nil Output file path
---@field use_quickfix boolean Should write to quickfix list
---@field level 'trace'|'debug'|'info'|'warn'|'error'|'fatal' Minimum log level
---@field modes table[] Level configuration with name and highlight
---@field float_precision number Decimals displayed for floats
---@field fmt_msg fun(is_console: boolean, mode_name: string, src_path: string, src_line: integer, msg: string): string Message formatter
---@field info_level integer|nil Debug info level

---@class PlenaryLogger
---@field trace fun(...: any): nil Log at trace level
---@field debug fun(...: any): nil Log at debug level
---@field info fun(...: any): nil Log at info level
---@field warn fun(...: any): nil Log at warn level
---@field error fun(...: any): nil Log at error level
---@field fatal fun(...: any): nil Log at fatal level
---@field fmt_trace fun(fmt: string, ...: any): nil Format and log at trace level
---@field fmt_debug fun(fmt: string, ...: any): nil Format and log at debug level
---@field fmt_info fun(fmt: string, ...: any): nil Format and log at info level
---@field fmt_warn fun(fmt: string, ...: any): nil Format and log at warn level
---@field fmt_error fun(fmt: string, ...: any): nil Format and log at error level
---@field fmt_fatal fun(fmt: string, ...: any): nil Format and log at fatal level

---@class plenary.log
local log = {}

--- Create a new logger instance
---@param config PlenaryLogConfig Logger configuration
---@param standalone boolean|nil If true, modifies log object directly instead of returning config
---@return PlenaryLogger logger Logger instance
function log.new(config, standalone) end

return log
