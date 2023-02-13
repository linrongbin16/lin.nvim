local keymap = require("conf/keymap")

--  ---- Text ----
-- live grep
keymap.map("n", "<space>r", keymap.exec("FzfRg"), { desc = "Search text" })
keymap.map(
  "n",
  "<space>ur",
  keymap.exec("FzfUnrestrictedRg"),
  { desc = "Search text unrestrictedly" }
)
keymap.map(
  "n",
  "<space>pr",
  keymap.exec("FzfPrecisedRg"),
  { desc = "Search text precisely" }
)
keymap.map(
  "n",
  "<space>upr",
  keymap.exec("FzfUnrestrictedPrecisedRg"),
  { desc = "Search text unrestrictedly and precisely" }
)
-- cursor word
keymap.map(
  "n",
  "<space>wr",
  keymap.exec("FzfCWordRg"),
  { desc = "Search cursor word" }
)
keymap.map(
  "n",
  "<space>uwr",
  keymap.exec("FzfUnrestrictedCWordRg"),
  { desc = "Search cursor word unrestrictedly" }
)
-- lines in current buffer
keymap.map("n", "<space>ln", keymap.exec("FzfLines"), { desc = "Search lines" })
-- tags
keymap.map("n", "<space>tg", keymap.exec("FzfTags"), { desc = "Search tags" })

-- ---- Files ----
-- files
keymap.map("n", "<space>f", keymap.exec("FzfFiles"), { desc = "Search files" })
keymap.map(
  "n",
  "<space>uf",
  keymap.exec("FzfUnrestrictedFiles"),
  { desc = "Search files unrestrictedly" }
)
-- files by cursor word
keymap.map(
  "n",
  "<space>wf",
  keymap.exec("FzfCWordFiles"),
  { desc = "Search files by cursor word" }
)
keymap.map(
  "n",
  "<space>uwf",
  keymap.exec("FzfUnrestrictedCWordFiles"),
  { desc = "Search files unrestrictedly by cursor word" }
)
-- opened buffers
keymap.map(
  "n",
  "<space>bf",
  keymap.exec("FzfBuffers"),
  { desc = "Search buffers" }
)
-- history files/oldfiles
keymap.map(
  "n",
  "<space>hf",
  keymap.exec("FzfHistory"),
  { desc = "Search history files" }
)

-- ---- History ----
-- search history
keymap.map(
  "n",
  "<space>hs",
  keymap.exec("FzfHistory/"),
  { desc = "Search *search* histories(/)" }
)
-- vim command history
keymap.map(
  "n",
  "<space>hc",
  keymap.exec("FzfHistory:"),
  { desc = "Search command histories(:)" }
)

-- ---- Git ----
-- git commits
keymap.map(
  "n",
  "<space>gc",
  keymap.exec("FzfCommits"),
  { desc = "Search git commits" }
)
-- git files
keymap.map(
  "n",
  "<space>gf",
  keymap.exec("FzfGFiles"),
  { desc = "Search git repository files(`git ls-files`)" }
)
-- git status files
keymap.map(
  "n",
  "<space>gs",
  keymap.exec("FzfGFiles?"),
  { desc = "Search git status files(`git status`)" }
)

-- ---- Vim ----
-- vim marks
keymap.map(
  "n",
  "<space>mk",
  keymap.exec("FzfMarks"),
  { desc = "Search vim marks" }
)
-- vim key mappings
keymap.map(
  "n",
  "<space>mp",
  keymap.exec("FzfMaps"),
  { desc = "Search key mappings" }
)
-- vim commands
keymap.map(
  "n",
  "<space>cm",
  keymap.exec("FzfCommands"),
  { desc = "Search vim commands" }
)
-- vim help tags
keymap.map(
  "n",
  "<space>ht",
  keymap.exec("FzfHelptags"),
  { desc = "Search helptags" }
)
-- vim colorschemes
keymap.map(
  "n",
  "<space>cs",
  keymap.exec("FzfColors"),
  { desc = "Search colorschemes" }
)
-- vim filetypes
keymap.map(
  "n",
  "<space>tp",
  keymap.exec("FzfFiletypes"),
  { desc = "Search filetypes" }
)
