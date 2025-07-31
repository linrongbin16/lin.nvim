local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")
local path = require("mason-core.path")

require("mason").setup({
  install_root_dir = path.concat({ vim.fn.stdpath("config"), "mason" }),
  ui = {
    border = constants.window.border,
    width = constants.layout.window.scale,
    height = layout.editor.height(constants.layout.window.scale, 1) - 2,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})
