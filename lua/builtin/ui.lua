-- ---- UI Options ----

local constants = require("builtin.constants")

-- window border
if vim.fn.has("nvim-0.11") > 0 then
  vim.g.winborder = constants.window.border
end

-- transparent
vim.o.winblend = constants.window.blend
vim.o.pumblend = constants.window.blend
