local keymap = require("conf/keymap")

--  ---- Text ----
-- live grep
keymap.map("n", "<space>r", keymap.exec("FzfRg"))
keymap.map("n", "<space>ur", keymap.exec("FzfUnrestrictedRg"))
keymap.map("n", "<space>pr", keymap.exec("FzfPrecisedRg"))
keymap.map("n", "<space>upr", keymap.exec("FzfUnrestrictedPrecisedRg"))
-- cursor word
keymap.map("n", "<space>wr", keymap.exec("FzfCWordRg"))
keymap.map("n", "<space>uwr", keymap.exec("FzfUnrestrictedCWordRg"))
-- lines in current buffer
keymap.map("n", "<space>ln", keymap.exec("FzfLines"))
-- tags
keymap.map("n", "<space>tg", keymap.exec("FzfTags"))

-- ---- Files ----
-- files
keymap.map("n", "<space>f", keymap.exec("FzfFiles"))
keymap.map("n", "<space>uf", keymap.exec("FzfUnrestrictedFiles"))
-- files by cursor word
keymap.map("n", "<space>wf", keymap.exec("FzfCWordFiles"))
keymap.map("n", "<space>uwf", keymap.exec("FzfUnrestrictedCWordFiles"))
-- opened buffers
keymap.map("n", "<space>bf", keymap.exec("FzfBuffers"))
-- history files/oldfiles
keymap.map("n", "<space>hf", keymap.exec("FzfHistory"))

-- ---- History ----
-- search history
keymap.map("n", "<space>hs", keymap.exec("FzfHistory/"))
-- vim command history
keymap.map("n", "<space>hc", keymap.exec("FzfHistory:"))

-- ---- Git ----
-- git commits
keymap.map("n", "<space>gc", keymap.exec("FzfCommits"))
-- git files
keymap.map("n", "<space>gf", keymap.exec("FzfGFiles"))
-- git status files
keymap.map("n", "<space>gs", keymap.exec("FzfGFiles?"))

-- ---- Vim ----
-- vim marks
keymap.map("n", "<space>mk", keymap.exec("FzfMarks"))
-- vim key mappings
keymap.map("n", "<space>mp", keymap.exec("FzfMaps"))
-- vim commands
keymap.map("n", "<space>cm", keymap.exec("FzfCommands"))
-- vim help tags
keymap.map("n", "<space>ht", keymap.exec("FzfHelptags"))
-- vim colorschemes
keymap.map("n", "<space>cs", keymap.exec("FzfColors"))
-- vim filetypes
keymap.map("n", "<space>tp", keymap.exec("FzfFiletypes"))
