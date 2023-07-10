-- Disable matchit
vim.g.loaded_matchit = 1
vim.g.matchup_matchparen_offscreen = { method = "popup" }
-- vim.g.matchup_matchparen_offscreen = { method = "status_manual" }

-- defer to better performance
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_matchparen_deferred_show_delay = 50
vim.g.matchup_matchparen_deferred_hide_delay = 500