local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key({ "n", "x" }, "<leader>cc", ":CodeCompanion ", { desc = "CodeCompanion" }),
  set_lazy_key({ "n" }, "<leader>ct", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanionChat" }),
}

return M
