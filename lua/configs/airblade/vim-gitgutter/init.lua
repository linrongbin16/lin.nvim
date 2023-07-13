-- disable default mappings
vim.g.gitgutter_map_keys = 0

-- don't clobber diagnostic sign
vim.g.gitgutter_sign_allow_clobber = 0
-- vim.g.gitgutter_sign_priority = 1

-- use rg to improve performance
if vim.fn.executable("rg") > 0 then
    vim.g.gitgutter_grep = "rg"
end

-- use float window for preview
vim.g.gitgutter_preview_win_floating = 1

-- gitsigns style signs
-- unicode symbols: https://symbl.cc/en/html-entities/
-- vim.g.gitgutter_sign_added = "┃" -- '+', U+2503
-- vim.g.gitgutter_sign_modified = "┃" -- '~', U+2503
-- vim.g.gitgutter_sign_removed = "▁" -- '_', U+2581
-- vim.g.gitgutter_sign_removed_first_line = "▔" -- '‾', U+2594
-- vim.g.gitgutter_sign_modified_removed = "┃" -- '~_', U+2503
-- vim.g.gitgutter_sign_removed_above_and_below = "▁" -- '_¯', U+2581