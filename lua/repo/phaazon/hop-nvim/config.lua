require("hop").setup()

local map = require("conf/keymap").map

map(
    { "n", "x" },
    "<leader>f",
    "<cmd>HopChar1AC<cr>",
    { desc = "Jump forward by {char}" }
)
map(
    { "n", "x" },
    "<leader>F",
    "<cmd>HopChar1BC<cr>",
    { desc = "Jump backward by {char}" }
)
map(
    { "n", "x" },
    "<leader>s",
    "<cmd>HopChar2AC<cr>",
    { desc = "Jump forward by {char}{char}" }
)
map(
    { "n", "x" },
    "<leader>S",
    "<cmd>HopChar2BC<cr>",
    { desc = "Jump backward by {char}{char}" }
)
map(
    { "n", "x" },
    "<leader>wd",
    "<cmd>HopWordAC<cr>",
    { desc = "Jump forward by word" }
)
map(
    { "n", "x" },
    "<leader>wD",
    "<cmd>HopWordBC<cr>",
    { desc = "Jump backward by word" }
)
map(
    { "n", "x" },
    "<leader>ln",
    "<cmd>HopLineAC<cr>",
    { desc = "Jump forward by line" }
)
map(
    { "n", "x" },
    "<leader>lN",
    "<cmd>HopLineBC<cr>",
    { desc = "Jump backward by line" }
)