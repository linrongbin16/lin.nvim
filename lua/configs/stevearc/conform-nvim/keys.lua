local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        { "n", "x" },
        "<Leader>cf",
        "<cmd>require('conform').format({ timeout_ms = 2000, lsp_fallback = true })<cr>",
        { desc = "Code format" }
    ),
}

return M
