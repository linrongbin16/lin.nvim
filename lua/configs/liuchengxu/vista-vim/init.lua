local layout = require("builtin.utils.layout")
local constants = require("builtin.constants")

vim.g.vista_sidebar_width = layout.editor.width(
  constants.window.layout.sidebar.scale,
  constants.window.layout.sidebar.min,
  constants.window.layout.sidebar.max
)
