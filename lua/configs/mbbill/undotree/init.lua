local neoconf = require("neoconf")
local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.layout")

vim.g.undotree_SplitWidth = layout.editor.width(
    neoconf.get("linopts.ui.sidebar.scale"),
    neoconf.get("linopts.ui.sidebar.min"),
    neoconf.get("linopts.ui.sidebar.max")
)
