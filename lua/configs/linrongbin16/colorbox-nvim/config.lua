local disabled_colors = {
  ["romainl/apprentice"] = true,
}

require("colorbox").setup({
  background = "dark",
  filter = {
    function(color_name, spec)
      return not disabled_colors[spec.handle]
    end,
  },
  policy = 'shuffle',
  debug = true,
  file_log = true,
})
