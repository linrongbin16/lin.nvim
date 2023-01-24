require("bufferline").setup{
    options = {
        numbers = "both",
        close_command = "Bdelete! %d",       -- Bdelete: https://github.com/famiu/bufdelete.nvim
        right_mouse_command = "Bdelete! %d",
        max_name_length = 60,
        max_prefix_length = 55,
        diagnostics = "nvim_lsp",
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
            }
        },
        hover = {
            enabled = false,
        },
    }
}

