local editor_layout = require("builtin.utils.layout").editor
local constants = require("builtin.utils.constants")

-- winblend
vim.g.rnvimr_shadow_winblend = 90

-- layout
vim.g.rnvimr_layout = {
    relative = "editor",
    width = constants.ui.layout.width,
    height = constants.ui.layout.height,
    col = editor_layout.width(0.025, 1, nil),
    row = editor_layout.height(0.075, 1, nil),
    style = "minimal",
}