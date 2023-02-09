" mark word
nnoremap <silent> <Leader>km :call InterestingWords('n')<CR>
vnoremap <silent> <Leader>km :call InterestingWords('v')<CR>
" unmark word
nnoremap <silent> <Leader>kM :call UncolorAllWords()<CR>
" navigate next word
nnoremap <silent> <Leader>kn :call WordNavigation(1)<CR>
" navigate previous word
nnoremap <silent> <Leader>kN :call WordNavigation(0)<CR>

" migrate more colors from [vim-mark](https://github.com/inkarkat/vim-mark)
" see: https://github.com/inkarkat/vim-mark/blob/master/autoload/mark/palettes.vim
" gui colors
let g:interestingWordsGUIColors = [
		\   '#8CCBEA',
		\   '#A4E57E',
		\   '#FFDB72',
		\   '#FF7272',
		\   '#FFB3FF',
		\   '#9999FF',
		\]

if has('gui_running') || &t_Co >= 88
		let g:interestingWordsGUIColors += [
		\   '#00005f',
		\   '#005f00',
		\   '#005f5f',
		\   '#005fff',
		\   '#00875f',
		\   '#00af00',
		\   '#00afaf',
		\   '#00d7af',
		\   '#00ff5f',
		\   '#5f0000',
		\   '#5f005f',
		\   '#5f5f00',
		\   '#5f5f87',
		\   '#5f8700',
		\   '#5f875f',
		\   '#5f8787',
		\   '#5faf87',
		\   '#5fafd7',
		\   '#5fd787',
		\   '#5fd7af',
		\   '#5fffaf',
		\]
endif

if has('gui_running') || &t_Co >= 256
		let g:interestingWordsGUIColors += [
		\   '#870087',
		\   '#875f5f',
		\   '#875f87',
		\   '#87875f',
		\   '#87af5f',
		\   '#87d787',
		\   '#87d7ff',
		\   '#87ff00',
		\   '#87ffd7',
		\   '#af5f00',
		\   '#af5f5f',
		\   '#af5faf',
		\   '#af8787',
		\   '#afaf00',
		\   '#afd7d7',
		\   '#d70000',
		\   '#d75f00',
		\   '#d75faf',
		\   '#d78787',
		\   '#d787af',
		\   '#d7d787',
		\   '#d7ff00',
		\   '#ff0087',
		\   '#ff5f00',
		\   '#ff5f87',
		\   '#ff875f',
		\   '#ff87d7',
		\   '#ffaf5f',
		\   '#ffd700',
		\   '#ffd7d7',
		\   '#ffff87',
		\]
endif
if has('gui_running')
		let g:interestingWordsGUIColors += [
		\   '#b3dcff',
		\   '#99cbd6',
		\   '#7afff0',
		\   '#a6ffd2',
		\   '#a2de9e',
		\   '#bcff80',
		\   '#e7ff8c',
		\   '#f2e19d',
		\   '#ffcc73',
		\   '#f7af83',
		\   '#fcb9b1',
		\   '#ff8092',
		\   '#ff73bb',
		\   '#fc97ef',
		\   '#c8a3d9',
		\   '#ac98eb',
		\   '#6a6feb',
		\   '#8caeff',
		\   '#70b9fa',
		\]
endif

" term colors
" let g:interestingWordsTermColors = ['154', '121', '211', '137', '214', '222']
let g:interestingWordsTermColors = [
		\   'Cyan',
		\   'Green',
		\   'Yellow',
		\   'Red',
		\   'Magenta',
		\   'Blue',
		\]

if has('gui_running') || &t_Co >= 88
		let g:interestingWordsTermColors += [
		\   '17',
		\   '22',
		\   '23',
		\   '27',
		\   '29',
		\   '34',
		\   '37',
		\   '43',
		\   '47',
		\   '52',
		\   '53',
		\   '58',
		\   '60',
		\   '64',
		\   '65',
		\   '66',
		\   '72',
		\   '74',
		\   '78',
		\   '79',
		\   '85',
		\]
endif

if has('gui_running') || &t_Co >= 256
		let g:interestingWordsTermColors += [
		\   '90', 
		\   '95', 
		\   '96', 
		\   '101',
		\   '107',
		\   '114',
		\   '117',
		\   '118',
		\   '122',
		\   '130',
		\   '131',
		\   '133',
		\   '138',
		\   '142',
		\   '152',
		\   '160',
		\   '166',
		\   '169',
		\   '174',
		\   '175',
		\   '186',
		\   '190',
		\   '198',
		\   '202',
		\   '204',
		\   '209',
		\   '212',
		\   '215',
		\   '220',
		\   '224',
		\   '228',
		\]
endif
