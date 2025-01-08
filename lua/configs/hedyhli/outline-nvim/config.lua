local constants = require("builtin.constants")

require("outline").setup({
  outline_window = {
    width = constants.window.layout.sidebar.scale * 100,
    focus_on_open = false,
  },
  symbol_folding = {
    autofold_depth = 5,
    auto_unfold = {
      hovered = false,
    },
  },
  symbols = {
    filter = {
      "Property",
      "Field",
      "String",
      "Number",
      "Boolean",
      "Null",
      "Variable",
      "Constant",
      "Package",
      "Array",
      exclude = true,
    },
  },
})
