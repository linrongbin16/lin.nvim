local layout = require("builtin.utils.layout")
local color_hl = require("commons.color.hl")

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

local white = "#ffffff"
local black = "#000000"

local function setup_current_color()
  local bg = color_hl.get_color_with_fallback(
    { "StatusLine", "PmenuSel", "PmenuThumb", "TabLineSel" },
    "bg",
    black
  )
  local fg = color_hl.get_color_with_fallback({ "Normal", "StatusLine", "TabLineSel" }, "fg", white)
  vim.api.nvim_set_hl(0, "BufferCurrent", { fg = fg, bg = bg })
  vim.api.nvim_set_hl(0, "BufferIndex", { fg = fg })
end

local barbar_augroup = vim.api.nvim_create_augroup("barbar_augroup", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = barbar_augroup,
  callback = setup_current_color,
})
vim.api.nvim_create_autocmd("VimEnter", {
  group = barbar_augroup,
  callback = setup_current_color,
})
