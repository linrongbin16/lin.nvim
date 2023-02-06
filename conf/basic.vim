""" ---- Basic settings ----

""" VI compatible
set nocompatible

""" bell
set noerrorbells novisualbell
set t_vb=
autocmd GUIEnter * set visualbell

""" file
set autoread autowrite noswapfile confirm
autocmd FocusGained,BufEnter,TermClose,TermLeave * checktime

""" editing
set backspace=indent,eol,start
set whichwrap+=b,s,<,>,[,]
set clipboard^=unnamed,unnamedplus
set history=1000

""" language
language messages en_US.UTF-8
set langmenu=en_US

""" encoding
" set fileformat=unix
" set fileformats=unix,dos,mac
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,gbk,big5,euc-jp,euc-kr,default,latin1
set encoding=utf-8
set termencoding=utf-8

""" mouse
set mouse=a
set selection=exclusive
set selectmode=mouse,key

""" indent
set cindent smartindent autoindent
set expandtab smarttab tabstop=4 softtabstop=4 shiftwidth=4

""" filetype
filetype on
filetype plugin indent on

""" syntax
syntax on

""" complete option
set completeopt=menu,menuone,preview

""" folding
set foldenable foldlevel=100 foldnestmax=100 foldmethod=indent

""" search
set magic smartcase ignorecase hlsearch
if has('patch-8.0.1238')
    set incsearch
endif

""" whitespace
set listchars=tab:>·,trail:~,extends:>,precedes:<,nbsp:+
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣,nbsp:+
set list

""" color and highlights
set background=dark
if has("termguicolors")
    set termguicolors
endif
set nocursorcolumn cursorline
" set colorcolumn=120

""" ui
set number norelativenumber ruler showcmd showmatch noshowmode wrap
set signcolumn=yes cmdheight=2 laststatus=3 scrolloff=3 shortmess+=c updatetime=300 display+=lastline
if has('patch-7.4.2109')
    set display+=truncate
endif

""" render
set redrawtime=1000 maxmempattern=100000

""" shorter timeout, better response
set timeoutlen=300

""" tags
set tags+=./tags,tags

""" disable save options in session and view
set sessionoptions-=options
set viewoptions-=options

""" disable GUI menu
set guioptions-=T
set guioptions-=m

""" maximize GUI window
if has("gui_running")
    set lines=9999
    set columns=9999
endif
if has('win32') || has('win64')
    autocmd GUIEnter * simalt ~x
endif

""" disable macvim GUI key mappings
if has("gui_macvim")
    let macvim_skip_cmd_opt_movement = 1
endif
