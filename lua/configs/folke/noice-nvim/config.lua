require("noice").setup({
  messages = {
    enabled = false,
  },
  notify = {
    enabled = false,
  },
  lsp = {
    progress = { enabled = false },
    hover = { enabled = false },
    signature = { enabled = true },
    message = { enabled = false },
  },
  health = { checker = false },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false,
    command_palette = false,
  },
})
