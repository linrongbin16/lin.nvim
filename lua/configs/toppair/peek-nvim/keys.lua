local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>pk", function()
    local peek = require("peek")
    if not peek.is_open() then
      peek.open()
    else
      peek.close()
    end
  end, { desc = "Peek toggle (for markdown preview)" }),
}

return M
