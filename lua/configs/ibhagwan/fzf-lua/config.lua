local constants = require("builtin.constants")

require("fzf-lua").setup({
  { "fzf-native" },
  winopts = {
    height = constants.layout.window.scale,
    width = constants.layout.window.scale,
    -- row = 0.35, -- window row position (0=top, 1=bottom)
    -- col = 0.50, -- window col position (0=left, 1=right)
    border = constants.window.border,
    treesitter = {
      enabled = false,
    },
    preview = {
      default = "bat",
      border = constants.window.border,
    },
  },
})
