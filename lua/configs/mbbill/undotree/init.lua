local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.layout")

vim.g.undotree_SplitWidth = layout.editor.width(
  constants.ui.layout.sidebar.scale,
  constants.ui.layout.sidebar.min,
  constants.ui.layout.sidebar.max
)
