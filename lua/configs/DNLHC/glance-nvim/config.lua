local glance = require("glance")
local layout = require("api.layout")

glance.setup({
  height = layout.editor.height(0.99, 3, 18),
  folds = {
    folded = false,
  },
  border = { enable = true },
})
