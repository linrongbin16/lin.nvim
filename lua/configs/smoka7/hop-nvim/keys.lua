local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        { "n", "x" },
        "<leader>f",
        "<cmd>HopChar1AC<cr>",
        { desc = "Jump forward by {char}" }
    ),
    set_lazy_key(
        { "n", "x" },
        "<leader>F",
        "<cmd>HopChar1BC<cr>",
        { desc = "Jump backward by {char}" }
    ),
    set_lazy_key(
        { "n", "x" },
        "<leader>s",
        "<cmd>HopChar2AC<cr>",
        { desc = "Jump forward by {char}{char}" }
    ),
    set_lazy_key(
        { "n", "x" },
        "<leader>S",
        "<cmd>HopChar2BC<cr>",
        { desc = "Jump backward by {char}{char}" }
    ),
    set_lazy_key(
        { "n", "x" },
        "<leader>j",
        "<cmd>HopLineAC<cr>",
        { desc = "Jump to below lines" }
    ),
    set_lazy_key(
        { "n", "x" },
        "<leader>k",
        "<cmd>HopLineBC<cr>",
        { desc = "Jump to above lines" }
    ),
    set_lazy_key(
        { "n", "x" },
        "<leader>h",
        "<cmd>HopChar1CurrentLineBC<cr>",
        { desc = "Jump to left" }
    ),
    set_lazy_key(
        { "n", "x" },
        "<leader>l",
        "<cmd>HopChar1CurrentLineAC<cr>",
        { desc = "Jump to right" }
    ),
}

return M