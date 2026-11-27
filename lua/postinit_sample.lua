-- Please copy this file to 'postinit.lua' to enable it.

-- ctrl/cmd-?
if vim.fn.exists("$VIMRUNTIME/mswin.vim") > 0 then
  vim.cmd([[source $VIMRUNTIME/mswin.vim]])
end
if vim.fn.has("mac") > 0 and vim.fn.exists("$VIMRUNTIME/macmap.vim") > 0 then
  vim.cmd([[source $VIMRUNTIME/macmap.vim]])
end

-- neovide configs
if vim.g.neovide then
  vim.o.guifont = "Monaco Nerd Font Mono:h12"
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_short_animation_length = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_smooth_blink = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0
end

-- ---- Rust Glancer LSP ----
-- executable: ~/.local/bin/rust-glancer
-- configuration: https://rust-glancer.github.io/docs/usage/CONFIGURE.html
-- conflict with: rust-analyzer / rustaceanvim.nvim
vim.lsp.config("rust_glancer", {
  cmd = { vim.fn.expand("~/.local/bin/rust-glancer"), "lsp" },
  init_options = {
    diagnostics = {
      onSave = true,
      -- onStartup = true, -- run `cargo check` on startup
    },
    -- cargo metadata enable all features
    cargo = {
      allFeatures = true,
    },
  },
})
-- lsp config enable it
vim.lsp.enable("rust_glancer")
