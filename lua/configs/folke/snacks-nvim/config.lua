local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("snacks").setup({
  styles = {
    input = {
      border = constants.window.border,
      width = function()
        return layout.editor.width(
          constants.layout.input.scale,
          constants.layout.input.min,
          constants.layout.input.max
        )
      end,
      height = 1,
      relative = "cursor",
      row = 1,
      col = 0,
      keys = {
        i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
      },
    },
    lazygit = {
      border = constants.window.border,
      height = function()
        local height = layout.editor.height(constants.layout.window.scale, 1)
        return height + 1
      end,
      width = function()
        local width = layout.editor.width(constants.layout.window.scale, 1)
        return width + 1
      end,
      relative = "editor",
      backdrop = false,
      wo = {
        spell = false,
        wrap = false,
      },
    },
  },
  indent = { enabled = true, animate = { enabled = false }, scope = { enabled = false } },
  input = { enabled = true },
  picker = {
    enabled = true,
    layouts = {
      select = {
        layout = {
          width = layout.editor.width(
            constants.layout.select.scale,
            constants.layout.select.min,
            constants.layout.select.max
          ),
          min_width = constants.layout.select.min,
          border = constants.window.border,
        },
      },
    },
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },
        },
      },
    },
  },
})
