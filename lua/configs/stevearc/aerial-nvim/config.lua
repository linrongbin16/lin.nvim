local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("aerial").setup({
  layout = {
    max_width = {
      constants.window.layout.sidebar.max,
      constants.window.layout.sidebar.scale,
    },
    width = layout.editor.width(
      constants.window.layout.sidebar.scale,
      constants.window.layout.sidebar.min,
      constants.window.layout.sidebar.max
    ),
    min_width = constants.window.layout.sidebar.min,
  },
})
