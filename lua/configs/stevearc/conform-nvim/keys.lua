local keymap = require("util.keymap")

local M = {
  keymap.set_lazily({ "n", "x" }, "<Leader>cf", function()
    require("conform").format({ lsp_fallback = "fallback" })
  end, { desc = "Code format" }),
}

return M
