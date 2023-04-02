local big_layout = require("cfg.const").ui.layout.big

require("buffer_manager").setup({
    select_menu_item_commands = {
        t = {
            key = "<C-t>",
            command = "tabnew",
        },
        v = {
            key = "<C-v>",
            command = "vsplit",
        },
        s = {
            key = "<C-s>",
            command = "split",
        },
    },
    width = big_layout.width,
    height = big_layout.height,
})