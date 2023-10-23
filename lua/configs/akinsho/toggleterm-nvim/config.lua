local neoconf = require("neoconf")
local layout = require("builtin.utils.layout")

require("toggleterm").setup({
    direction = "float",
    float_opts = {
        border = neoconf.get("linopts.ui.floatwin.border"),
        width = function()
            return layout.editor.width(neoconf.get("linopts.ui.floatwin.scale"))
        end,
        height = function()
            layout.editor.height(neoconf.get("linopts.ui.floatwin.scale"))
        end,
        winblend = neoconf.get("linopts.ui.blend.winblend"),
    },
})
