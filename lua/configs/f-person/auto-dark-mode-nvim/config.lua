local auto_dark_mode = require("auto-dark-mode")
auto_dark_mode.setup({
    update_interval = 5 * 60 * 1000,
    set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
    end,
    set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
    end,
})
auto_dark_mode.init()