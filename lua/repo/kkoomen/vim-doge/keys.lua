local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>dg",
        ":DogeGenerate ",
        { desc = "Generate document" }
    ),
}

return M