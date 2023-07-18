local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>ol",
        keymap.exec(function()
            require("oil").open()
        end),
        { desc = "Open oil file manager" }
    ),
}

return M