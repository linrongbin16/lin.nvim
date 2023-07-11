local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.layout")

require("toggleterm").setup({
    direction = "float",
    float_opts = {
        border = constants.ui.border,
        width = layout.editor.width(constants.ui.layout.width, 5, nil),
        height = layout.editor.height(constants.ui.layout.height, 5, nil),
        winblend = constants.ui.winblend,
    },
})