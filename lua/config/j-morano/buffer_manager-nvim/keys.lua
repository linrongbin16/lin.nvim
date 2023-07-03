local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>bm",
        "<cmd>lua require('buffer_manager.ui').toggle_quick_menu()<cr>",
        { desc = "Toggle buffer manager" }
    ),
}

return M
