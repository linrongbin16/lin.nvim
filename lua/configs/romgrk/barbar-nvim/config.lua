local layout = require("builtin.utils.layout")

require("barbar").setup({
  animation = false,
  clickable = false,
  icons = {
    buffer_index = true,
    diagnostics = {
      enabled = false,
    },
    gitsigns = {
      enabled = false,
    },
  },
  maximum_length = layout.editor.width(0.334, 60, nil),
  no_name_title = "[No Name]",
})
