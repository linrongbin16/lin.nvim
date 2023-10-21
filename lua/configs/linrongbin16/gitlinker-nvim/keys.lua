local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key({ "n", "x" }, "<leader>gl", function()
        require("gitlinker").link({
            action = require("gitlinker.actions").clipboard,
        })
    end, { desc = "Copy git link to clipboard" }),
    set_lazy_key({ "n", "x" }, "<leader>gL", function()
        require("gitlinker").link({
            action = require("gitlinker.actions").system,
        })
    end, { desc = "Open git link in browser" }),
}

return M
