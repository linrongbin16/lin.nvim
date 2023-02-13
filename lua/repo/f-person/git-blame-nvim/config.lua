-- toggle git blame
require("conf/keymap").map(
  "n",
  "<leader>gb",
  "<cmd>GitBlameToggle<cr>",
  { desc = "Toggle git blame" }
)
