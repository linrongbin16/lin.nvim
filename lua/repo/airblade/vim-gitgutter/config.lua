local map = require("conf/keymap").map

map("n", "]h", "<Plug>(GitGutterNextHunk)", { desc = "Next git hunk" })
map("n", "[h", "<Plug>(GitGutterPrevHunk)", { desc = "Previous git hunk" })
