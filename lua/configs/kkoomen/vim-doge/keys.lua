local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>dg",
        ":DogeGenerate ",
        { desc = "Generate document/annotation via doge" }
    ),
}

return M