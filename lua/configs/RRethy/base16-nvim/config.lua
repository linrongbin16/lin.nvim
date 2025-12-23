require("base16-colorscheme").setup()

local colors = vim.fn.getcompletion("", "color")
local n = #colors
local s = os.time()
local r = math.fmod(s, n)
local color = colors[r]
vim.cmd([[colorscheme ]] .. color)
