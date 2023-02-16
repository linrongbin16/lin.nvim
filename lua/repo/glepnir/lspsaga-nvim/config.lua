local constants = require("conf/constants")

require("lspsaga").setup({
    lightbulb = {
        enable = false,
    },
    ui = {
        border = constants.ui.border,
    },
})
