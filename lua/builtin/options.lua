-- ---- Basic Options ----

-- References:
-- * https://github.com/tpope/vim-sensible
-- * https://github.com/mhinz/vim-galore#tips-1

-- keys move to previous/next line
vim.opt.whichwrap:append("b,s,<,>,[,]")

-- complete option
vim.opt.completeopt:append("menu,menuone,preview")

-- indent with 4 spaces
vim.opt.cindent = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- clipboard with system
vim.opt.clipboard:prepend("unnamedplus")

-- keycode timeout
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 200
-- updatetime
vim.opt.updatetime = 300

-- search
vim.opt.magic = true
vim.opt.smartcase = true
vim.opt.ignorecase = false
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- clean highlight
vim.keymap.set(
    "n",
    "<C-L>",
    ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>",
    { silent = true, noremap = true }
)

-- match brackets
vim.opt.showmatch = true

-- cursor/line/column
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
-- vim.opt.colorcolumn=120
vim.opt.wrap = true

-- sidebar: number, signcolumn
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"

-- statusline
vim.opt.ruler = true
vim.opt.showmode = false
vim.opt.laststatus = 3

-- command line and message
vim.opt.wildmenu = true
vim.opt.showcmd = true
vim.opt.display:append("lastline,truncate")
vim.opt.shortmess:append("c")
vim.opt.cmdheight = 2

-- scroll
vim.opt.scrolloff = 1
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 2

-- whitespace
vim.opt.listchars = "tab:>·,trail:~,extends:>,precedes:<,nbsp:+"
-- set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣,nbsp:+
vim.opt.list = true

-- delete extra comments when formatting
vim.opt.formatoptions:append("j")

-- render
vim.opt.redrawtime = 1000
vim.opt.maxmempattern = 2000000

-- search tags from current file to all ancestor folders
vim.opt.tags:append("./tags;,tags")

-- file auto read/write/load
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.swapfile = false
vim.opt.confirm = true
vim.api.nvim_create_autocmd(
    { "FocusGained", "BufEnter", "TermEnter", "TermLeave" },
    {
        pattern = "*",
        callback = function()
            vim.cmd.checktime()
        end,
    }
)

-- encodings
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings:append(
    "ucs-bom,utf-8,cp936,gb18030,gbk,big5,euc-jp,euc-kr,default,latin1"
)
vim.opt.encoding = "utf-8"
vim.opt.termencoding = "utf-8"
-- set fileformat=unix
-- set fileformats=unix,dos,mac

-- vim command history
vim.opt.history = 1000
-- tabs
vim.opt.tabpagemax = 100

-- disable save options in session and view files
vim.opt.sessionoptions:remove("options")
vim.opt.viewoptions:remove("options")

-- true colors and dark
vim.opt.background = "dark"
vim.opt.termguicolors = true

-- english language
vim.opt.langmenu = "en_US"
vim.opt.langremap = false

-- allow mouse
vim.opt.mouse = "a"
vim.opt.selection = "exclusive"
vim.opt.selectmode = "mouse,key"

-- folding
vim.opt.foldenable = true
vim.opt.foldlevel = 100
vim.opt.foldnestmax = 100
vim.opt.foldmethod = "indent"
