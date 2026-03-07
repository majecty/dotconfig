local M = {}

vim.notify("Loading fugitive clone")

---@diagnostic disable-next-line: unused-local
function M.setup(_opts)
  vim.notify("Setting up fugitive clone")
end

local M = {}

function M.jgit(args)
  if args == "status" then
    require("fugitive-clone.status").show_status()
  end
end

---@diagnostic disable-next-line: unused-local
function M.jgit_complete(arg_lead, cmd_line, cursor_pos)
  local git_commands = {
    "add",
    "commit",
    "push",
    "pull",
    "status",
    "log",
    "diff",
    "checkout",
    "branch",
    "merge",
    "rebase",
    "stash",
    "tag",
    "remote",
    "fetch",
  }
  return vim.tbl_filter(function(cmd)
    return vim.startswith(cmd, arg_lead)
  end, git_commands)
end

return M
