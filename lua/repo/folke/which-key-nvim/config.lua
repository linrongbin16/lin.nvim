local constants = require("conf/constants")

require("which-key").setup({
    window = {
        border = constants.ui.border,
    },
})

require("conf/keymap").map("n", "<leader>wk", ":WhichKey ", { silent = false, desc = "Open WhichKey" })
