require("auto-save").setup({
    execution_message = {
        message = function()
            return ("[auto-save.nvim] saved at " .. vim.fn.strftime("%H:%M:%S"))
        end,
    },
    debounce_delay = 1000,
})