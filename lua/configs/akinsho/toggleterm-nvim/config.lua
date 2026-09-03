local constants = require("api.constants")
local layout = require("api.layout")

require("toggleterm").setup({
  persist_size = false,
  direction = "float",
  float_opts = {
    border = constants.window.border,
    winblend = constants.window.blend,
    width = layout.editor.width(constants.layout.window.scale, 10),
    height = layout.editor.height(constants.layout.window.scale, 10),
  },
})
