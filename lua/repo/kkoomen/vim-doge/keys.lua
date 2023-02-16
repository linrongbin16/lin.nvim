local map_lazy = require("conf/keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>gd",
        ":DogeGenerate ",
        { desc = "Generate document" }
    ),
}

return M
