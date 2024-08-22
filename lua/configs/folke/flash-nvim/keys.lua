local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key({ "n", "x", "o" }, "s", function()
    require("flash").jump()
  end, { desc = "Jump" }),
  set_lazy_key({ "o" }, "r", function()
    require("flash").remote()
  end, { desc = "Jump in operator-pending" }),
}

return M
