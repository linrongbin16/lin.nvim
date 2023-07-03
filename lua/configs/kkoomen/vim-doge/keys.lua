local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>gd",
        ":DogeGenerate ",
        { desc = "Generate document" }
    ),
}

return M