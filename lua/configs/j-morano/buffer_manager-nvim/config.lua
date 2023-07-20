local constants = require("builtin.utils.constants")

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
    width = constants.ui.layout.middle.scale,
    height = constants.ui.layout.middle.scale,
})