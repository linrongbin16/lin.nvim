local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.layout")

require("buffer_manager").setup({
    select_menu_item_commands = {
        t = {
            key = "<C-w>t",
            command = "tabnew",
        },
        v = {
            key = "<C-w>v",
            command = "vsplit",
        },
        s = {
            key = "<C-w>s",
            command = "split",
        },
    },
    width = layout.editor.width(constants.ui.layout.width, 5, nil),
    height = layout.editor.height(constants.ui.layout.height, 5, nil),
})