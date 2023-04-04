local const = require("cfg.const")

require("toggleterm").setup({
    direction = "float",
    float_opts = {
        border = const.ui.border,
        width = const.ui.layout.big.width,
        height = const.ui.layout.big.height,
    },
})