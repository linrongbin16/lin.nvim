local constants = require("builtin.utils.constants")

require("toggleterm").setup({
    direction = "float",
    float_opts = {
        border = constants.ui.border,
        width = constants.ui.layout.width,
        height = constants.ui.layout.height,
    },
})