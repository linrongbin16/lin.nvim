local keymap = require("cfg.keymap")

local M = {

    --  ---- Text ----
    -- live grep
    keymap.map_lazy(
        "n",
        "<space>r",
        keymap.exec("FzfRg2"),
        { desc = "Search text" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ur",
        keymap.exec("FzfUnrestrictedRg"),
        { desc = "Search text unrestrictedly" }
    ),
    keymap.map_lazy(
        "n",
        "<space>pr",
        keymap.exec("FzfPrecisedRg"),
        { desc = "Search text precisely" }
    ),
    keymap.map_lazy(
        "n",
        "<space>upr",
        keymap.exec("FzfUnrestrictedPrecisedRg"),
        { desc = "Search text unrestrictedly and precisely" }
    ),
    -- cursor word
    keymap.map_lazy(
        "n",
        "<space>wr",
        keymap.exec("FzfCWordRg"),
        { desc = "Search cursor word" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uwr",
        keymap.exec("FzfUnrestrictedCWordRg"),
        { desc = "Search cursor word unrestrictedly" }
    ),
    -- lines in current buffer
    keymap.map_lazy(
        "n",
        "<space>ln",
        keymap.exec("FzfLines"),
        { desc = "Search lines" }
    ),
    -- tags
    keymap.map_lazy(
        "n",
        "<space>tg",
        keymap.exec("FzfTags"),
        { desc = "Search tags" }
    ),

    -- ---- Files ----
    -- files
    keymap.map_lazy(
        "n",
        "<space>f",
        keymap.exec("FzfFiles"),
        { desc = "Search files" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec("FzfUnrestrictedFiles"),
        { desc = "Search files unrestrictedly" }
    ),
    -- files by cursor word
    keymap.map_lazy(
        "n",
        "<space>wf",
        keymap.exec("FzfCWordFiles"),
        { desc = "Search files by cursor word" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uwf",
        keymap.exec("FzfUnrestrictedCWordFiles"),
        { desc = "Search files unrestrictedly by cursor word" }
    ),
    -- opened buffers
    keymap.map_lazy(
        "n",
        "<space>bf",
        keymap.exec("FzfBuffers"),
        { desc = "Search buffers" }
    ),
    -- history files/oldfiles
    keymap.map_lazy(
        "n",
        "<space>hf",
        keymap.exec("FzfHistory"),
        { desc = "Search history files" }
    ),

    -- ---- History ----
    -- search history
    keymap.map_lazy(
        "n",
        "<space>hs",
        keymap.exec("FzfHistory/"),
        { desc = "Search *search* histories(/)" }
    ),
    -- vim command history
    keymap.map_lazy(
        "n",
        "<space>hc",
        keymap.exec("FzfHistory:"),
        { desc = "Search command histories(:)" }
    ),

    -- ---- Git ----
    -- git commits
    keymap.map_lazy(
        "n",
        "<space>gc",
        keymap.exec("FzfCommits"),
        { desc = "Search git commits" }
    ),
    -- git files
    keymap.map_lazy(
        "n",
        "<space>gf",
        keymap.exec("FzfGFiles"),
        { desc = "Search git repository files(`git ls-files`)" }
    ),
    -- git status files
    keymap.map_lazy(
        "n",
        "<space>gs",
        keymap.exec("FzfGFiles?"),
        { desc = "Search git status files(`git status`)" }
    ),

    -- ---- Vim ----
    -- vim marks
    keymap.map_lazy(
        "n",
        "<space>mk",
        keymap.exec("FzfMarks"),
        { desc = "Search vim marks" }
    ),
    -- vim key mappings
    keymap.map_lazy(
        "n",
        "<space>mp",
        keymap.exec("FzfMaps"),
        { desc = "Search key mappings" }
    ),
    -- vim commands
    keymap.map_lazy(
        "n",
        "<space>cm",
        keymap.exec("FzfCommands"),
        { desc = "Search vim commands" }
    ),
    -- vim help tags
    keymap.map_lazy(
        "n",
        "<space>ht",
        keymap.exec("FzfHelptags"),
        { desc = "Search helptags" }
    ),
    -- vim colorschemes
    keymap.map_lazy(
        "n",
        "<space>cs",
        keymap.exec("FzfColors"),
        { desc = "Search colorschemes" }
    ),
    -- vim filetypes
    keymap.map_lazy(
        "n",
        "<space>tp",
        keymap.exec("FzfFiletypes"),
        { desc = "Search filetypes" }
    ),
}

return M