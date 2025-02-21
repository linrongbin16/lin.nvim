require("flash").setup({
  search = {
    mode = function(s)
      -- Always search ignorecase
      return "\\C" .. s
    end,
  },
})
