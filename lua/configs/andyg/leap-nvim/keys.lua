local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key({ "n", "x", "o" }, "s", function()
    local saved = vim.o.ignorecase
    vim.o.ignorecase = true
    require("leap").leap({
      windows = { vim.api.nvim_get_current_win() },
      inclusive = true,
    })
    vim.o.ignorecase = saved
  end, { desc = "Jump with s{char1}{char2}" }),
  set_lazy_key("n", "S", function()
    local saved = vim.o.ignorecase
    vim.o.ignorecase = true
    require("leap").leap({
      windows = require("leap.user").get_enterable_windows(),
    })
    vim.o.ignorecase = saved
  end, { desc = "Jump to other windows with s{char1}{char2}" }),
}

return M
