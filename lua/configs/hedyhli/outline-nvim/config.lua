local constants = require("builtin.constants")

require("outline").setup({
  outline_window = {
    width = constants.window.layout.sidebar.scale * 100,
  },
  symbol_folding = {
    autofold_depth = 5,
  },
})
