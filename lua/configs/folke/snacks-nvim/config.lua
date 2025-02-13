local constants = require("builtin.constants")

require("snacks").setup({
  indent = { enabled = true, animate = { enabled = false }, scope = { enabled = false } },
  input = {
    enabled = true,
    win = { border = constants.window.border, relative = "cursor", row = 1, col = 0 },
    keys = {
      i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
    },
  },
})
