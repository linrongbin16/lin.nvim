local disabled_colors = {
  ["navarasu/onedark.nvim"] = true,
  ["zenbones-theme/zenbones.nvim"] = true,
  ["rrethy/base16-nvim"] = true,
  ["ayu-theme/ayu-vim"] = true,
  ["romainl/apprentice"] = true,
}

require("colorbox").setup({
  background = "dark",
  filter = {
    "primary",
    function(color, spec)
      return spec.github_stars >= 800
    end,
    function(color, spec)
      return type(spec.handle) == "string" and not disabled_colors[spec.handle]
    end,
  },
})
