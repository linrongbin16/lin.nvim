local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key({ "n", "x", "o" }, "s", function()
        require("flash").jump()
    end, { desc = "Flash jump" }),
    keymap.set_lazy_key({ "n", "x", "o" }, "S", function()
        require("flash").treesitter()
    end, { desc = "Flash treesitter" }),
}

return M