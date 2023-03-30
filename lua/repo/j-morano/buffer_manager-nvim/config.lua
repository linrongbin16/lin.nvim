local width_on_editor = require("cfg.ui").width_on_editor
local height_on_editor = require("cfg.ui").height_on_editor
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
    width = width_on_editor(
        big_layout.width.pct,
        big_layout.width.min,
        big_layout.width.max
    ),
    height = height_on_editor(
        big_layout.height.pct,
        big_layout.height.min,
        big_layout.height.max
    ),
})