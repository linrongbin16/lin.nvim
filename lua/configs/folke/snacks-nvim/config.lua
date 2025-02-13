local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("snacks").setup({
  styles = {
    input = {
      border = constants.window.border,
      width = layout.editor.width(
        constants.window.layout.input.scale,
        constants.window.layout.input.min,
        constants.window.layout.input.max
      ),
      height = 1,
      relative = "cursor",
      row = 1,
      col = 0,
      keys = {
        i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
      },
    },
  },
  indent = { enabled = true, animate = { enabled = false }, scope = { enabled = false } },
  input = { enabled = true },
  picker = {
    enabled = true,
    ui_select = true,
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },
        },
      },
    },
  },
})
