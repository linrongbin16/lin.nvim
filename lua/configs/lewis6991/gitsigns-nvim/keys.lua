local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      require("gitsigns").nav_hunk("next")
    end
  end, { desc = "Go to next git hunk" }),
  set_lazy_key("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      require("gitsigns").nav_hunk("prev")
    end
  end, { desc = "Go to previous git hunk" }),
}

return M
