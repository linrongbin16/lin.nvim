local keymap = require("cfg.keymap")

local M = {
    keymap.map_lazy(
        "n",
        "<leader>gb",
        "<cmd>Gitsigns toggle_current_line_blame<cr>",
        { desc = "Toggle git blame" }
    ),
}

return M