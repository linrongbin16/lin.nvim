require("gitlinker").setup({
    mappings = "<leader>gl",
    action_callback = require("gitlinker.actions").open_in_browser,
})
