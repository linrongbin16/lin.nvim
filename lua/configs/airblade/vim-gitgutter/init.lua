-- disable default mappings
vim.g.gitgutter_map_keys = 0

-- don't clobber diagnostic sign
vim.g.gitgutter_sign_allow_clobber = 0

-- use rg to improve performance
if vim.fn.executable("rg") > 0 then
  vim.g.gitgutter_grep = "rg"
end

-- use float window for preview
vim.g.gitgutter_preview_win_floating = 1
