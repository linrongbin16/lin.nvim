require("hop").setup()

local map = require("conf/keymap").map

-- <Leader><Leader>f{char} - move to {char} forward
map(
  { "n", "x" },
  "<leader><leader>f",
  ":HopChar1AC<CR>",
  { desc = "Jump forward by {char}" }
)

-- <Leader><Leader>F{char} - move to {char} backward
map(
  { "n", "x" },
  "<leader><leader>F",
  ":HopChar1BC<CR>",
  { desc = "Jump backward by {char}" }
)

-- <Leader><Leader>s{char}{char} - move to {char}{char} forward
map(
  { "n", "x" },
  "<leader><leader>s",
  ":HopChar2AC<CR>",
  { desc = "Jump forward by {char}{char}" }
)

-- <Leader><Leader>S{char}{char} - move to {char}{char} backward
map(
  { "n", "x" },
  "<leader><leader>S",
  ":HopChar2BC<CR>",
  { desc = "Jump backward by {char}{char}" }
)

-- <Leader><Leader>w - move to word forward
map(
  { "n", "x" },
  "<leader><leader>w",
  ":HopWordAC<CR>",
  { desc = "Jump forward by word" }
)

-- <Leader><Leader>W - move to word backward
map(
  { "n", "x" },
  "<leader><leader>W",
  ":HopWordBC<CR>",
  { desc = "Jump backward by word" }
)

-- <Leader><Leader>l - move to line forward
map(
  { "n", "x" },
  "<leader><leader>l",
  ":HopLineAC<CR>",
  { desc = "Jump forward by line" }
)

-- <Leader><Leader>L - move to line backward
map(
  { "n", "x" },
  "<leader><leader>L",
  ":HopLineBC<CR>",
  { desc = "Jump backward by line" }
)
