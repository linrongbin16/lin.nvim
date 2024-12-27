" ---- Basic Options ----

" References:
" * https://github.com/tpope/vim-sensible
" * https://github.com/mhinz/vim-galore#tips-1

" cursor movement
set whichwrap+=b,s,<,>,[,]

" complete option
set completeopt+=menu,menuone,preview

" indent
set cindent
set smartindent
set autoindent
set expandtab
set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" editorconfig
let g:editorconfig=1

" local rc
set exrc

" system clipboard
set clipboard^=unnamedplus

" timeout
set ttimeout
set ttimeoutlen=200
set updatetime=300

" search
set magic
set smartcase
set ignorecase
set hlsearch
set incsearch

" clean highlight
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" match brackets
set showmatch

" cursor/line/column
set wrap
set cursorline
set nocursorcolumn
" set colorcolumn=120
set number
set norelativenumber
set signcolumn=yes

" statusline
set ruler
set noshowmode
set laststatus=3

" command line, message
set wildmenu
set showcmd
set display+=lastline,truncate
set shortmess+=c
" set cmdheight=2

" scroll
set scrolloff=1
set sidescroll=1
set sidescrolloff=2

" whitespace
set list
set listchars=tab:>·,trail:~,extends:>,precedes:<,nbsp:+
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣,nbsp:+


" render
set redrawtime=1000
set maxmempattern=2000000

" tags
set tags+=./tags;,tags

" files
set autoread
set autowrite
set noswapfile
set noconfirm
autocmd FocusGained,BufEnter,TermEnter,TermLeave * checktime

" encodings
set fileencoding=utf-8
set fileencodings+=ucs-bom,utf-8,cp936,gb18030,gbk,big5,euc-jp,euc-kr,default,latin1
set encoding=utf-8
" set termencoding=utf-8
" set fileformat=unix
" set fileformats=unix,dos,mac

" command history
set history=1000
" tabs
set tabpagemax=100
" buffers
set hidden

" options
set formatoptions+=j
set sessionoptions-=options
set viewoptions-=options

" color
set termguicolors
set background=dark

" language
set nolangremap
set langmenu=en_US

" mouse, selection
set mouse=a
set selection=exclusive
set selectmode=mouse,key

" fold
set foldenable
set foldlevel=100
set foldnestmax=100
set foldmethod=indent

" jump
set jumpoptions=stack,view
