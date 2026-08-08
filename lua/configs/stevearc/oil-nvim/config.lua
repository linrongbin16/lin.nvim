require("oil").setup({
  columns = {
    "icon",
    "permissions",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 3000,
  },
  watch_for_changes = true,
  keymaps = {
    ["<BS>"] = { "actions.parent", mode = "n" },
    ["."] = { "actions.select", mode = "n" },
  },
  view_options = {
    show_hidden = true,
  },
})
