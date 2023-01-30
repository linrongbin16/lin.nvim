require("bufferline").setup({
    options = {
        numbers = function(opts)
            return string.format("%s.%s", opts.ordinal, opts.lower(opts.id))
        end,
        max_name_length = 60,
        max_prefix_length = 55,
        diagnostics = false,
        offsets = {
            {
                filetype = "NvimTree",
                text = "NvimTree",
            },
            {
                filetype = "neo-tree",
                text = "neo-tree",
            },
        },
        -- separator_style = "slant",
        hover = {
            enabled = false,
        },
    },
})
