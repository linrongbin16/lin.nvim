local neoconf = require("neoconf")

require("which-key").setup({
    window = {
        border = neoconf.get("linopts.ui.floatwin.border"),
    },
})
