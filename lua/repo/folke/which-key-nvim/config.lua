require("which-key").setup({
    window = {
        border = require("conf/constants").ui.border,
    },
})

require("conf/keymap").map(
    "n",
    "<leader>wk",
    ":WhichKey ",
    { silent = false, desc = "Open WhichKey" }
)
