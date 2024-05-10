local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

local shell = vim.o.shell
if constants.os.is_windows then
  shell = vim.fn.executable("pwsh") > 0 and "pwsh" or "powershell"
end

require("toggleterm").setup({
  direction = "float",
  float_opts = {
    border = constants.window.border,
    width = function()
      return layout.editor.width(constants.window.layout.middle.scale, nil, nil)
    end,
    height = function()
      layout.editor.height(constants.window.layout.middle.scale, nil, nil)
    end,
    winblend = constants.window.blend,
  },
  shell = shell,
})
