local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        { "n", "x" },
        "<leader>f",
        "<cmd>HopChar1AC<cr>",
        { desc = "Jump forward by {char}" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>F",
        "<cmd>HopChar1BC<cr>",
        { desc = "Jump backward by {char}" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>s",
        "<cmd>HopChar2AC<cr>",
        { desc = "Jump forward by {char}{char}" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>S",
        "<cmd>HopChar2BC<cr>",
        { desc = "Jump backward by {char}{char}" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>j",
        "<cmd>HopLineAC<cr>",
        { desc = "Jump to below lines" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>k",
        "<cmd>HopLineBC<cr>",
        { desc = "Jump to above lines" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>h",
        "<cmd>HopChar1CurrentLineBC<cr>",
        { desc = "Jump to left" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>l",
        "<cmd>HopChar1CurrentLineAC<cr>",
        { desc = "Jump to right" }
    ),
}

return M