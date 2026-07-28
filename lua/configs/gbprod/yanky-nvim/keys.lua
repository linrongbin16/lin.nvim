local keymap = require("util.keymap")

local M = {
  -- put
  keymap.set_lazily(
    { "n", "x" },
    "p",
    "<Plug>(YankyPutAfter)",
    { desc = "Put after cursor (yanky)" }
  ),
  keymap.set_lazily(
    { "n", "x" },
    "P",
    "<Plug>(YankyPutBefore)",
    { desc = "Put before cursor (yanky)" }
  ),
  keymap.set_lazily(
    { "n", "x" },
    "gp",
    "<Plug>(YankyGPutAfter)",
    { desc = "Put after cursor and leave the cursor after (yanky)" }
  ),
  keymap.set_lazily(
    { "n", "x" },
    "gP",
    "<Plug>(YankyGPutBefore)",
    { desc = "Put before cursor and leave the cursor after (yanky)" }
  ),
  -- yank
  keymap.set_lazily({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank (yanky)" }),
}

return M
