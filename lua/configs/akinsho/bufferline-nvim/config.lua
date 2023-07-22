local layout = require("builtin.utils.layout")

require("bufferline").setup({
    options = {
        -- numbers = function(opts)
        --     return string.format("%s.%s", opts.ordinal, opts.lower(opts.id))
        -- end,
        numbers = "ordinal",
        close_command = "Bdelete! %d", -- Bdelete: https://github.com/moll/vim-bbye
        right_mouse_command = "Bdelete! %d",
        name_formatter = function(buf)
            local max_name_len = layout.editor.width(0.334, 60, nil)
            local name = buf.name
            local len = name ~= nil and string.len(name) or 0
            if len > max_name_len then
                local half = math.floor(max_name_len / 2) - 1
                local left = string.sub(name, 1, half)
                local right = string.sub(name, len - half, len)
                name = left .. "…" .. right
            end
            return name
        end,
        max_name_length = layout.editor.width(0.334, 60, nil),
        max_prefix_length = layout.editor.width(0.1, 10, 18),
        diagnostics = false,
        -- separator_style = "slant",
        hover = {
            enabled = false,
        },
    },
})