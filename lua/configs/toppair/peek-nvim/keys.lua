local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>pk", function()
    local peek = require("peek")
    if not peek.is_open() then
      peek.open()
    else
      peek.close()
    end
  end, { desc = "Peek toggle (for markdown preview)" }),
}

return M
