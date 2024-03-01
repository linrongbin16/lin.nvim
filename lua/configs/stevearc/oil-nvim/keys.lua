local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>ol", function()
    require("oil").open()
  end, { desc = "Open oil file manager" }),
}

return M
