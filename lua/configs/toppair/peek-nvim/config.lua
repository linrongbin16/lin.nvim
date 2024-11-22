require("peek").setup({
  theme = "light",
  app = "browser",
})

vim.api.nvim_create_user_command(
  "PeekOpen",
  require("peek").open,
  { desc = "Peek open (for markdown preview)" }
)
vim.api.nvim_create_user_command(
  "PeekClose",
  require("peek").close,
  { desc = "Peek close (for markdown preview)" }
)
