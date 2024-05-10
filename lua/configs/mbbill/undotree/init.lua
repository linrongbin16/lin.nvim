local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

vim.g.undotree_SplitWidth = layout.editor.width(
  constants.window.layout.sidebar.scale,
  constants.window.layout.sidebar.min,
  constants.window.layout.sidebar.max
)
