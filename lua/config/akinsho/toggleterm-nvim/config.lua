local const = require("cfg.const")

require("toggleterm").setup({
    direction = "float",
    float_opts = {
        border = const.ui.border,
        width = const.ui.layout.width,
        height = const.ui.layout.height,
    },
})