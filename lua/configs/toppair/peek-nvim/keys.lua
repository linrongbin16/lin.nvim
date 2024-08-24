local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key(
    "n",
    "<leader>pk",
    require("peek").open,
    { silent = false, desc = "Open peek markdown preview" }
  ),
}

return M
