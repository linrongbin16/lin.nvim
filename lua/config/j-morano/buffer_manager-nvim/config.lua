local layout = require("builtin.utils.constants").ui.layout

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
    width = layout.width,
    height = layout.height,
})