local editor_layout = require("builtin.utils.layout").editor
local MAX_NAME_LENGTH = editor_layout.width(0.334, 15, 80)
local MAX_PREFIX_LENGTH = editor_layout.width(0.1, 10, 15)

require("bufferline").setup({
    options = {
        -- numbers = function(opts)
        --     return string.format("%s.%s", opts.ordinal, opts.lower(opts.id))
        -- end,
        numbers = "ordinal",
        close_command = "Bdelete! %d", -- Bdelete: https://github.com/moll/vim-bbye
        right_mouse_command = "Bdelete! %d",
        name_formatter = function(buf)
            local name = buf.name
            local len = name ~= nil and string.len(name) or 0
            if len > MAX_NAME_LENGTH then
                local half = math.floor(MAX_NAME_LENGTH / 2) - 1
                local left = string.sub(name, 1, half)
                local right = string.sub(name, len - half, len)
                name = left .. "…" .. right
            end
            return name
        end,
        max_name_length = MAX_NAME_LENGTH,
        max_prefix_length = MAX_PREFIX_LENGTH,
        diagnostics = false,
        -- separator_style = "slant",
        hover = {
            enabled = false,
        },
    },
})