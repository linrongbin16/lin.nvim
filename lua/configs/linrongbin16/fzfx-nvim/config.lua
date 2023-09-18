local constants = require("builtin.utils.constants")

require("fzfx").setup({
    debug = {
        enable = true,
        file_log = true,
    },
    popup = {
        win_opts = {
            height = constants.ui.layout.middle.scale,
            width = constants.ui.layout.middle.scale,
        },
    },
})
