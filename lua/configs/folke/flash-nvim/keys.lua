local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

-- Always search in 'ignorecase' mode.
local M = {
  set_lazy_key({ "n", "x", "o" }, "s", function()
    local gi = vim.go.ignorecase
    local gs = vim.go.smartcase
    vim.go.ignorecase = true
    vim.go.smartcase = false
    require("flash").jump()
    vim.go.ignorecase = gi
    vim.go.smartcase = gs
  end, { desc = "Jump" }),
  set_lazy_key({ "o" }, "r", function()
    local gi = vim.go.ignorecase
    local gs = vim.go.smartcase
    vim.go.ignorecase = true
    vim.go.smartcase = false
    require("flash").remote()
    vim.go.ignorecase = gi
    vim.go.smartcase = gs
  end, { desc = "Jump in operator-pending" }),
}

return M
