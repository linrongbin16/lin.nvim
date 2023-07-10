local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>ng",
        ":Neogen<CR>",
        { desc = "Generate document/annotation (neogen)" }
    ),
}

return M