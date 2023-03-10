require("bufferline").setup({
    options = {
        numbers = function(opts)
            return string.format("%s.%s", opts.ordinal, opts.lower(opts.id))
        end,
        -- numbers = "ordinal",
        close_command = "Bdelete! %d", -- Bdelete: https://github.com/moll/vim-bbye
        right_mouse_command = "Bdelete! %d",
        max_name_length = 60,
        max_prefix_length = 55,
        diagnostics = false,
        -- separator_style = "slant",
        hover = {
            enabled = false,
        },
    },
})