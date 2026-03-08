local M = {}

---@param fn fun():nil
function M.exec(fn)
  coroutine.resume(coroutine.create(fn))
end

---@param fn fun(..., callback: fun(...):nil):nil
function M.wrap(fn)
  return function(...)
    ---@type thread | nil
    local co = coroutine.running()
    assert(co, "wrap can only be called inside a coroutine")

    local args = { ... }
    fn(unpack(args), function(...)
      local once_co = co
      co = nil

      if once_co == nil then
        vim.notify("Callback called multiple times", vim.log.levels.WARN)
        return
      end

      if coroutine.status(once_co) == "dead" then
        vim.notify("Coroutine already finished", vim.log.levels.WARN)
        return
      end
      coroutine.resume(once_co, ...)
    end)

    return coroutine.yield()
  end
end

---@param ms number
function M.sleep(ms)
  local wrapped = M.wrap(function(duration, callback)
    local uv = vim.uv
    local timer = uv.new_timer()
    assert(timer, "Failed to create timer")
    uv.timer_start(timer, duration, 0, function()
      timer:stop()
      timer:close()
      callback()
    end)
  end)

  return wrapped(ms)
end

return M
