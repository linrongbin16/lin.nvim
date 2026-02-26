local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("barbar").setup({
  animation = false,
  tabpages = false,
  icons = {
    buffer_index = true,
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true, icon = constants.diagnostics.error },
      [vim.diagnostic.severity.HINT] = { enabled = true, icon = constants.diagnostics.hint },
    },
    separator = { left = "▎", right = "" },
  },
  maximum_padding = 1,
  minimum_padding = 1,
  maximum_length = layout.editor.width(0.33, 60, nil),
  minimum_length = 1,
  no_name_title = "[No Name]",
})
