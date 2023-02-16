require("urlview").setup({})

local map = require("conf/keymap").map
map("n", "<leader>ub", "<cmd>UrlView<cr>", { desc = "View buffer urls" })
map("n", "<leader>up", "<cmd>UrlView lazy<cr>", { desc = "View plugin urls" })
