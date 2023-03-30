local width_on_editor = require("cfg.ui").width_on_editor
local height_on_editor = require("cfg.ui").height_on_editor
local primary_modal = require("cfg.const").ui.modal.primary

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
        primary_modal.width.pct,
        primary_modal.width.min,
        primary_modal.width.max
    ),
    height = height_on_editor(
        primary_modal.height.pct,
        primary_modal.height.min,
        primary_modal.height.max
    ),
})