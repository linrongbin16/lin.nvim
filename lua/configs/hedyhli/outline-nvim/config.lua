local constants = require("builtin.constants")

require("outline").setup({
  outline_window = {
    width = constants.window.layout.sidebar.scale * 100,
    focus_on_open = false,
  },
  symbol_folding = {
    autofold_depth = false,
  },
  symbols = {
    filter = {
      "File",
      "Module",
      "Namespace",
      "Package",
      "Class",
      "Method",
      "Constructor",
      "Enum",
      "Interface",
      "Function",
      "Constant",
      "EnumMember",
      "Struct",
      "Event",
      "Component",
      "Fragment",
      "TypeAlias",
      "StaticMethod",
      "Macro",
    },
  },
})
