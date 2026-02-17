-- Neovide configuration
if vim.g.neovide then
  -- Very simple animation: only cursor animations, minimal transitions
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_length = 0.1
  vim.g.neovide_scroll_animation_length = 0.1

  -- Disable other animations
  vim.g.neovide_floating_blur_amount_x = 0
  vim.g.neovide_floating_blur_amount_y = 0

  -- Smooth scroll
  vim.opt.smoothscroll = true
end
