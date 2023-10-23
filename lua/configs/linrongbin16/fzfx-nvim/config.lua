local neoconf = require("neoconf")

require("fzfx").setup({
    env = {
        nvim = "nvim",
    },
    popup = {
        win_opts = {
            height = neoconf.get("linopts.ui.floatwin.scale"),
            width = neoconf.get("linopts.ui.floatwin.scale"),
        },
    },
})
