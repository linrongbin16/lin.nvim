local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      require("gitsigns").nav_hunk("next")
    end
  end, { desc = "Go to next git hunk" }),
  keymap.set_lazily("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      require("gitsigns").nav_hunk("prev")
    end
  end, { desc = "Go to previous git hunk" }),
  keymap.set_lazily("n", "<leader>gb", function()
    vim.cmd("Gitsigns blame")
  end, { desc = "Toggle buffer line blame" }),
}

return M
