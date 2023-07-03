local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key("n", "]u", nil, { desc = "Next url" }),
    set_lazy_key("n", "[u", nil, { desc = "Previous url" }),
    set_lazy_key(
        "n",
        "<leader>ub",
        "<cmd>UrlView<cr>",
        { desc = "View buffer urls" }
    ),
    set_lazy_key(
        "n",
        "<leader>up",
        "<cmd>UrlView lazy<cr>",
        { desc = "View plugin urls" }
    ),
}

return M