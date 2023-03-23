local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>gb",
        "<cmd>Gitsigns toggle_current_line_blame<cr>",
        { desc = "Toggle git blame" }
    ),
}
return M
