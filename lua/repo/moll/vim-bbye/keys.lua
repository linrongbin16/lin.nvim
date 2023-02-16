local keymap = require("conf/keymap")

local M = {}

-- close buffer
table.insert(
    M,
    keymap.map_lazy(
        "n",
        "<leader>bd",
        keymap.exec("Bdelete"),
        { desc = "Close buffer" }
    )
)
table.insert(
    M,
    keymap.map_lazy(
        "n",
        "<leader>bD",
        keymap.exec("Bdelete!"),
        { desc = "Close buffer forcibly!" }
    )
)

return M
