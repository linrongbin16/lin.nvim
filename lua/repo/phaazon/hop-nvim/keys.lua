local map_lazy = require("conf/keymap").map_lazy

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
        "<leader>wd",
        "<cmd>HopWordAC<cr>",
        { desc = "Jump forward by word" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>wD",
        "<cmd>HopWordBC<cr>",
        { desc = "Jump backward by word" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>ln",
        "<cmd>HopLineAC<cr>",
        { desc = "Jump forward by line" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>lN",
        "<cmd>HopLineBC<cr>",
        { desc = "Jump backward by line" }
    ),
}

return M