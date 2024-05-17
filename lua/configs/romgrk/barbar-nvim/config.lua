local layout = require("builtin.utils.layout")

require("barbar").setup({
  animation = false,
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

local function setup_color()
  vim.api.nvim_set_hl(0, "BufferCurrentIndex", { link = "BufferCurrent" })
  vim.api.nvim_set_hl(0, "BufferInactiveIndex", { link = "BufferInactive" })
end

local barbar_augroup = vim.api.nvim_create_augroup("barbar_augroup", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  group = barbar_augroup,
  callback = setup_color,
})
