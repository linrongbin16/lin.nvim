require("colorbox").setup({
    background = "dark",
    filter = {
        "primary",
        function(color, spec)
            return spec.github_stars >= 800
        end,
        function(color, spec)
            return spec.handle ~= "navarasu/onedark.nvim"
        end,
    },
})
