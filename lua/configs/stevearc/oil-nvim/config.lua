local constants = require("builtin.constants")

require("oil").setup({
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  delete_to_trash = vim.fn.executable("trash") > 0,
  trash_command = "trash",
  view_options = {
    show_hidden = true,
  },
  float = {
    border = constants.window.border,
  },
  preview = {
    border = constants.window.border,
  },
  progress = {
    border = constants.window.border,
  },
})
