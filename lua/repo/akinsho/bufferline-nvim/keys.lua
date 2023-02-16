local keymap = require("conf/keymap")

local M = {}

-- go to absolute buffer 1~9, and 0
for i = 1, 9 do
    table.insert(
        M,
        keymap.map_lazy(
            "n",
            string.format("<leader>%d", i),
            keymap.exec(
                string.format(
                    "lua require('bufferline').go_to_buffer(%d, true)",
                    i
                )
            ),
            { desc = string.format("Go to buffer-%d", i) }
        )
    )
end
table.insert(
    M,
    keymap.map_lazy(
        "n",
        "<leader>0",
        keymap.exec("lua require('bufferline').go_to_buffer(-1, true)"),
        { desc = "Go to the last buffer" }
    )
)

-- go to next/previous buffer
table.insert(
    M,
    keymap.map_lazy(
        "n",
        "]b",
        keymap.exec("BufferLineCycleNext"),
        { desc = "Go to next buffer" }
    )
)
table.insert(
    M,
    keymap.map_lazy(
        "n",
        "[b",
        keymap.exec("BufferLineCyclePrev"),
        { desc = "Go to previous buffer" }
    )
)

-- re-order/move current buffer to next/previous position
table.insert(
    M,
    keymap.map_lazy(
        "n",
        "<leader>.",
        keymap.exec("BufferLineMoveNext"),
        { desc = "Move buffer to next" }
    )
)
table.insert(
    M,
    keymap.map_lazy(
        "n",
        "<leader>,",
        keymap.exec("BufferLineMovePrev"),
        { desc = "Move buffer to previous" }
    )
)

return M
