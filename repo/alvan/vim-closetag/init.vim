" Enable by filenames
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml,*.js,*.jsx,*.ts,*.tsx,*.erb'

" Enable xhtml by filenames
let g:closetag_xhtml_filenames = '*.xhtml,*.xml,*.js,*.jsx,*.ts,*.tsx,*.erb'

" Enable by filetypes
let g:closetag_filetypes = 'html,xhtml,phtml,xml,javascript,javascriptreact,typescript,typescriptreact,eruby'

" Enable xhtml by filetypes
let g:closetag_xhtml_filetypes = 'xhtml,xml,javascript,javascriptreact,typescript,typescriptreact,eruby'

" Sensitive cases
let g:closetag_emptyTags_caseSensitive = 1

" Enable on all regions
let g:closetag_regions = {
   \ 'typescript.tsx': '',
   \ 'javascript.jsx': '',
   \ 'typescriptreact': '',
   \ 'javascriptreact': '',
   \ }

" Closing tags using >
let g:closetag_shortcut = '>'

" Add > without closing tag
let g:closetag_close_shortcut = '<leader>>'