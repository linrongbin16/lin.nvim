local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("blame").setup({
  max_summary_width = layout.editor.width(
    constants.window.layout.sidebar.scale,
    constants.window.layout.sidebar.min,
    constants.window.layout.sidebar.max
  ),
})
