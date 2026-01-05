local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key({ "n", "x" }, "<leader>ca", function()
    require("tiny-code-action").code_action()
  end, { desc = "Code Actions" }),
}

return M
