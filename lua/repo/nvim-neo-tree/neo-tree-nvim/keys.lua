local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>nt",
        "<cmd>Neotree toggle reveal<cr>",
        { silent = false, desc = "Toggle file explorer" }
    ),
}

return M