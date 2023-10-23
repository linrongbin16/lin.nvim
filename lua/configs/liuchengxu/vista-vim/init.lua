local neoconf = require("neoconf")
local layout = require("builtin.utils.layout")

vim.g.vista_sidebar_width = layout.editor.width(
    neoconf.get("linopts.ui.sidebar.scale"),
    neoconf.get("linopts.ui.sidebar.min"),
    neoconf.get("linopts.ui.sidebar.max")
)
