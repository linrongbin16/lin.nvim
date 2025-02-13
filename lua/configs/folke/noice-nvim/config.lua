local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("noice").setup({
  messages = {
    enabled = false,
  },
  notify = {
    enabled = false,
  },
  lsp = {
    progress = { enabled = false },
    hover = { enabled = false },
    signature = { enabled = true },
    message = { enabled = false },
  },
  health = { checker = false },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false,
    command_palette = false,
  },
  views = {
    cmdline_popup = {
      position = {
        row = "20%",
        col = "50%",
      },
      size = {
        width = layout.editor.width(
          constants.window.layout.cmdline.scale,
          constants.window.layout.cmdline.min,
          constants.window.layout.cmdline.max
        ),
        height = 1,
      },
      border = {
        style = constants.window.border,
      },
    },
  },
})
