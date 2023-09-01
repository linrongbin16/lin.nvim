local constants = require("builtin.utils.constants")

require("fzfx").setup({
    popup = {
        win_opts = {
            height = constants.ui.layout.middle.scale,
            width = constants.ui.layout.middle.scale,
        },
    },
})