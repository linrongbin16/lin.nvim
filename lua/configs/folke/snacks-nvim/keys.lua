local keymap = require("util.keymap")

local M = {
  keymap.set_lazily("n", "<leader>lg", function()
    local Snacks = require("snacks")
    Snacks.lazygit.open()
  end, { desc = "Toggle lazygit" }),
  -- keymap.set_lazily("n", "<leader>bd", function()
  --   local Snacks = require("snacks")
  --   Snacks.bufdelete()
  -- end, { desc = "Close buffer" }),
  -- keymap.set_lazily("n", "<leader>bD", function()
  --   local Snacks = require("snacks")
  --   Snacks.bufdelete({ force = true })
  -- end, { desc = "Close buffer forcibly!" }),
}

return M
