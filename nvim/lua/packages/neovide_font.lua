-- Neovide font size management
local M = {}

local DEFAULT_FONT_SIZE = 14
local MIN_FONT_SIZE = 8
local MAX_FONT_SIZE = 32
local STEP = 1

function M.get_font_size()
  if vim.g.neovide_scale_factor then
    return vim.g.neovide_scale_factor
  end
  return 1.0
end

function M.increase_font()
  local current = M.get_font_size()
  local new_size = current + (STEP / DEFAULT_FONT_SIZE)
  if new_size <= (MAX_FONT_SIZE / DEFAULT_FONT_SIZE) then
    vim.g.neovide_scale_factor = new_size
    vim.notify(string.format('Font size: %.1f', new_size * DEFAULT_FONT_SIZE), vim.log.levels.INFO)
  else
    vim.notify('Max font size reached', vim.log.levels.WARN)
  end
end

function M.decrease_font()
  local current = M.get_font_size()
  local new_size = current - (STEP / DEFAULT_FONT_SIZE)
  if new_size >= (MIN_FONT_SIZE / DEFAULT_FONT_SIZE) then
    vim.g.neovide_scale_factor = new_size
    vim.notify(string.format('Font size: %.1f', new_size * DEFAULT_FONT_SIZE), vim.log.levels.INFO)
  else
    vim.notify('Min font size reached', vim.log.levels.WARN)
  end
end

function M.reset_font()
  vim.g.neovide_scale_factor = 1.0
  vim.notify(string.format('Font size reset: %d', DEFAULT_FONT_SIZE), vim.log.levels.INFO)
end

return M
