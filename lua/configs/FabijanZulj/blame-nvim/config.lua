local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("blame").setup({
  max_summary_width = layout.editor.width(
    constants.layout.sidebar.scale,
    constants.layout.sidebar.min,
    constants.layout.sidebar.max
  ),
})
