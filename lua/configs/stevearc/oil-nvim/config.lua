require("oil").setup({
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 3000,
  },
})
