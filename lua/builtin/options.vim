""" ---- Basic Options ----

""" References:
""" * https://github.com/tpope/vim-sensible
""" * https://github.com/mhinz/vim-galore#tips-1

""" no VI compatible
set nocompatible

""" filetype on
filetype on
filetype plugin indent on

""" syntax on
syntax on
syntax enable

""" no bell
set noerrorbells novisualbell
set t_vb=
autocmd GUIEnter * set visualbell

""" backspace delete
set backspace=indent,eol,start
""" keys move to previous/next line
set whichwrap+=b,s,<,>,[,]

""" complete option
set completeopt=menu,menuone,preview

""" indent with 4 spaces
set cindent smartindent autoindent
set expandtab smarttab tabstop=4 softtabstop=4 shiftwidth=4

""" clipboard with system
set clipboard^=unnamedplus

""" shorter keycode timeout, better response
set ttimeout ttimeoutlen=200
""" shorter updatetime, better response
set updatetime=300

""" search
set magic smartcase noignorecase hlsearch
if has('patch-8.0.1238')
    set incsearch
endif

" clean highlight
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

""" brackets
set showmatch

""" cursor/line/column
set cursorline nocursorcolumn wrap
" set colorcolumn=120

""" side bar: number, signcolumn
set number norelativenumber signcolumn=yes

""" status line
set ruler noshowmode laststatus=3

""" command line and message
set wildmenu showcmd display+=lastline shortmess+=c
if has('patch-7.4.2109')
    set display+=truncate
endif

""" scroll
set scrolloff=1 sidescroll=1 sidescrolloff=2

""" whitespace
set listchars=tab:>·,trail:~,extends:>,precedes:<,nbsp:+
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣,nbsp:+
set list

""" delete extra comments when formatting
set formatoptions+=j

""" render
set redrawtime=1000 maxmempattern=2000000

""" search tags from current file to all ancestor folders
set tags+=./tags;,tags

""" file auto read/write/load
set autoread autowrite noswapfile confirm
autocmd FocusGained,BufEnter * checktime
if has('nvim') && exists('##TermEnter') && exists('##TermLeave')
    autocmd TermEnter,TermLeave * checktime
endif

""" encodings
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,gbk,big5,euc-jp,euc-kr,default,latin1
set encoding=utf-8
set termencoding=utf-8
" set fileformat=unix
" set fileformats=unix,dos,mac

""" vim command history
set history=1000

""" tabs
set tabpagemax=100

""" disable save options in session and view files
set sessionoptions-=options
set viewoptions-=options

""" true colors and dark
set background=dark
if has('termguicolors')
    set termguicolors
endif

""" EN language
set langmenu=en_US
set nolangremap

""" allow mouse
set mouse=a
set selection=exclusive
set selectmode=mouse,key

""" folding
set foldenable foldlevel=100 foldnestmax=100 foldmethod=indent

""" disable GUI menu
set guioptions-=T
set guioptions-=m

""" maximize GUI window
if !has('nvim')
    if has('gui_running')
        set lines=999
        set columns=999
    endif
    if has('win32') || has('win64')
        autocmd GUIEnter * simalt ~x
    endif
endif