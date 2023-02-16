local map_lazy = require("conf/keymap").map_lazy

local M = {
    -- toggle git blame
    map_lazy(
        "n",
        "<leader>gb",
        "<cmd>GitBlameToggle<cr>",
        { desc = "Toggle git blame" }
    ),
}

return M
