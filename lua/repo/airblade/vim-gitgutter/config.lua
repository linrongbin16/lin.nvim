local map = require("conf/keymap").map

map("n", "]c", "<Plug>(GitGutterNextHunk)", { desc = "Next git hunk" })
map("n", "[c", "<Plug>(GitGutterPrevHunk)", { desc = "Previous git hunk" })
