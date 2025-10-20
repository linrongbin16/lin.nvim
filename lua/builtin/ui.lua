-- ---- UI Options ----

local constants = require("builtin.constants")
local set_key = require("builtin.utils.keymap").set_key

-- window border
if vim.fn.has("nvim-0.11") > 0 then
  vim.g.winborder = constants.window.border
end

-- transparent
vim.o.winblend = constants.window.blend
vim.o.pumblend = constants.window.blend

-- adjust window size
set_key("n", "<leader>>", "<cmd>vertical resize +10<cr>", { desc = "vertical resize +10" })
set_key("n", "<leader><", "<cmd>vertical resize -10<cr>", { desc = "vertical resize -10" })
