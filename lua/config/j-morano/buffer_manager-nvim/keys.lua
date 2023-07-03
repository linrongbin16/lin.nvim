local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>bm",
        "<cmd>lua require('buffer_manager.ui').toggle_quick_menu()<cr>",
        { desc = "Toggle buffer manager" }
    ),
}

return M