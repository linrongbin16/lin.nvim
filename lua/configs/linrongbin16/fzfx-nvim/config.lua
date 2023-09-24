local constants = require("builtin.utils.constants")

require("fzfx").setup({
    env = {
        nvim = "nvim",
    },
    popup = {
        win_opts = {
            height = constants.ui.layout.middle.scale,
            width = constants.ui.layout.middle.scale,
        },
    },
})
