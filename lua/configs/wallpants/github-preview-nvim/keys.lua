local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>gp",
        "<cmd>lua require('github-preview').fns.toggle()<cr>",
        { desc = "Toggle markdown github previewer" }
    ),
}

return M
