local layout = require("builtin.utils.layout")

require("barbar").setup({
  animation = false,
  tabpages = false,
  icons = {
    buffer_index = true,
  },
  maximum_length = layout.editor.width(0.33, 60, nil),
  no_name_title = "[No Name]",
})
