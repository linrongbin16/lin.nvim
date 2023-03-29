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
        h = {
            key = "<C-x>",
            command = "split",
        },
    },
})