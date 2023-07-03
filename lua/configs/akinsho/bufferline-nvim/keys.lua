local keymap = require("builtin.utils.keymap")

local M = {
    -- go to the last buffer
    keymap.set_lazy_key(
        "n",
        "<leader>0",
        keymap.exec("lua require('bufferline').go_to_buffer(-1, true)"),
        { desc = "Go to the last buffer" }
    ),

    -- go to next/previous buffer
    keymap.set_lazy_key(
        "n",
        "]b",
        keymap.exec("BufferLineCycleNext"),
        { desc = "Go to next buffer" }
    ),
    keymap.set_lazy_key(
        "n",
        "[b",
        keymap.exec("BufferLineCyclePrev"),
        { desc = "Go to previous buffer" }
    ),

    -- move/re-order buffer to next/previous position
    keymap.set_lazy_key(
        "n",
        "<leader>.",
        keymap.exec("BufferLineMoveNext"),
        { desc = "Move buffer to next" }
    ),
    keymap.set_lazy_key(
        "n",
        "<leader>,",
        keymap.exec("BufferLineMovePrev"),
        { desc = "Move buffer to previous" }
    ),
}

-- go to absolute buffer 1~9
for i = 1, 9 do
    table.insert(
        M,
        keymap.set_lazy_key(
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

return M