-- toggle git blame
local map = require("conf/keymap").map

map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>")
