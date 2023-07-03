let g:gutentags_project_root = [
            \ '.svn',
            \ '.git',
            \ '.hg',
            \ 'package.json',
            \ 'CMakeLists.txt',
            \ 'Makefile',
            \ 'makefile',
            \ 'pom.xml',
            \ '.idea',
            \ '.vscode',
            \ 'Gemfile',
            \ 'Gemfile.lock',
            \ 'Cargo.toml',
            \ 'Cargo.lock',
            \ ]

let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 1

if executable('fd')
    let g:gutentags_file_list_command = 'fd -tf -tl -L'
elseif executable('fdfind')
    let g:gutentags_file_list_command = 'fdfind -tf -tl -L'
elseif executable('rg')
    let g:gutentags_file_list_command = 'rg --files'
endif

let g:gutentags_ctags_exclude = [
            \ '*.git', '*.svg', '*.hg',
            \ '*/tests/*',
            \ 'build',
            \ 'dist',
            \ '*sites/*/files/*',
            \ 'bin',
            \ 'node_modules',
            \ 'bower_components',
            \ 'cache',
            \ 'compiled',
            \ 'docs',
            \ 'example',
            \ 'bundle',
            \ 'vendor',
            \ '*.md',
            \ '*-lock.json',
            \ '*.lock',
            \ '*bundle*.js',
            \ '*build*.js',
            \ '.*rc*',
            \ '*.json',
            \ '*.min.*',
            \ '*.map',
            \ '*.bak',
            \ '*.zip',
            \ '*.pyc',
            \ '*.class',
            \ '*.sln',
            \ '*.Master',
            \ '*.csproj',
            \ '*.tmp',
            \ '*.csproj.user',
            \ '*.cache',
            \ '*.pdb',
            \ 'tags*',
            \ 'cscope.*',
            \ '*.css',
            \ '*.less',
            \ '*.scss',
            \ '*.exe', '*.dll',
            \ '*.mp3', '*.ogg', '*.flac',
            \ '*.swp', '*.swo',
            \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
            \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
            \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
            \ ]

let g:gutentags_cache_dir = expand('~/.cache/nvim/tags')
" create folder if not exists
if !isdirectory(g:gutentags_cache_dir)
    silent! call mkdir(g:gutentags_cache_dir, 'p', 0700)
endif

let g:gutentags_ctags_extra_args = [
            \ '--fields=+ailmnzS',
            \ '--extras=+q',
            \ '--c++-kinds=+px',
            \ '--c-kinds=+px',
            \ '--output-format=e-ctags',
            \ '--recurse=no',
            \ ]