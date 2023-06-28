local editor_width = require("cfg.ui").editor_width
local editor_height = require("cfg.ui").editor_height

vim.g.undotree_SplitWidth = editor_width(0.2, 10, 30)
vim.g.undotree_DiffpanelHeight = editor_height(0.4, 10, 40)