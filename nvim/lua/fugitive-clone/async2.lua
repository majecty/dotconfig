local M = {}

function M.exec(fn)
  local outer_co, is_main = coroutine.running()

  local co = coroutine.create(function()
    local ret = fn();

    if outer_co ~= nil then
      coroutine.resume(outer_co, ret)
    end

    return ret;
  end)

  local success, result_or_err = coroutine.resume(co)
  if not success then
    vim.notify("Error in async.exec: " .. tostring(result_or_err), vim.log.levels.ERROR)
  end

  if outer_co == nil or is_main == true then
    return nil
  end

  local ret = coroutine.yield()
  return ret;
end

function M.wrap(fn)
  return function(...)
    ---@type thread | nil
    local co = coroutine.running()
    assert(co, "wrap can only be called inside a coroutine")

    local args = { ... }
    fn(unpack(args), function(err, ...)
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
      coroutine.resume(once_co, err, ...)
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

---@param cmd string
---@param args string[]
function M.job(cmd, args)
  local wrapped = M.wrap(function(command, arguments, callback)
    ---@cast command string
    ---@cast arguments string[]

    local stdouts = {}
     vim.fn.jobstart({ command, unpack(arguments) }, {
      on_stdout = function(_, data, _)
        if data then
          for _, line in ipairs(data) do
            if line ~= "" then
              table.insert(stdouts, line)
            end
          end
        end
      end,
      on_exit = function(_, exit_code, _)
        if exit_code ~= 0 then
          vim.notify(string.format("Command '%s' failed with exit code %d", command, exit_code), vim.log.levels.ERROR)
        end
        callback(stdouts)
      end,
    })
    callback()
  end)

  return wrapped(cmd, args)
end


return M
