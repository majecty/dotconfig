local M = {}

---Wrap a callback-based function to look synchronous
---@param fn function The callback-based function (last arg is callback)
---@return function A wrapped function that yields/resumes automatically
function M.wrap(fn)
  return function(...)
    local co = coroutine.running()
    assert(co, "async.wrap must be called inside a coroutine")
    
    local args = {...}
    local resolved = false
    
    fn(unpack(args), function(...)
      if resolved then
        vim.notify("Warning: callback called multiple times", vim.log.levels.WARN)
        return
      end
      resolved = true
      
      if coroutine.status(co) == "suspended" then
        coroutine.resume(co, ...)
      end
    end)
    
    return coroutine.yield()
  end
end

---Execute an async function
---Can be called from top-level (async) or inside a coroutine (sync-like)
---@param fn function The async function to execute
---@param on_complete? function Optional callback for top-level calls
function M.exec(fn, on_complete)
  local caller_co = coroutine.running()
  
  if not caller_co then
    -- Top-level: execute and optionally use callback
    local co = coroutine.create(fn)
    
    local function step(...)
      local ok, result = coroutine.resume(co, ...)
      if coroutine.status(co) == "dead" then
        if on_complete then
          on_complete(result)
        end
        return
      end
      -- Handle async operations...
    end
    
    step()
    return
  end
  
  -- Inside coroutine: use wrap pattern to wait for completion
  local resolved = false
  local final_result = nil
  
  -- Create an executor that accepts a callback
  local function executor(resolve)
    local inner_co = coroutine.create(fn)
    
    local function step(...)
      local ok, result = coroutine.resume(inner_co, ...)
      
      if coroutine.status(inner_co) == "dead" then
        if not resolved then
          resolved = true
          final_result = result
          resolve(result)
        end
        return
      end
      
      -- Handle wrapped async operations
      if type(result) == "table" and result._async then
        result.run(function(job_result)
          vim.schedule(function()
            step(job_result)
          end)
        end)
      end
    end
    
    step()
  end
  
  -- Use wrap to convert executor to sync-like call
  local wrapped = M.wrap(executor)
  return wrapped()
end

---Create a sleep/delay function
---@param ms number Milliseconds to sleep
---@return function A wrapped sleep function
function M.sleep(ms)
  return M.wrap(function(duration, callback)
    local timer = vim.loop.new_timer()
    vim.loop.timer_start(timer, duration, 0, function()
      timer:stop()
      timer:close()
      vim.schedule(function()
        callback()
      end)
    end)
  end)(ms)
end

return M
