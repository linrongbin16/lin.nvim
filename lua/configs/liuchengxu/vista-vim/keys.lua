local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>vs",
        ":Vista!!<CR>",
        { silent = false, desc = "Toggle vista structure outlines" }
    ),
}

return M