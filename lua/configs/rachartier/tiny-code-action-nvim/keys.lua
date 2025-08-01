local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>ca", function()
    require("tiny-code-action").code_action()
  end, { desc = "Run LSP code action" }),
  set_lazy_key("x", "<leader>ca", function()
    require("tiny-code-action").code_action()
  end, { desc = "Run LSP code action on visual selection" }),
}

return M
