local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("outline").setup({
  outline_window = {
    width = constants.window.layout.sidebar.scale * 100,
  },
})
