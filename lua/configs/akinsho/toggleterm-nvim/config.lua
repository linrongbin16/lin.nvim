local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.layout")

require("toggleterm").setup({
    direction = "float",
    float_opts = {
        border = constants.ui.border,
        width = function()
            return layout.editor.width(
                constants.ui.layout.middle.scale,
                nil,
                nil
            )
        end,
        height = function()
            layout.editor.height(constants.ui.layout.middle.scale, nil, nil)
        end,
        winblend = constants.ui.winblend,
    },
})