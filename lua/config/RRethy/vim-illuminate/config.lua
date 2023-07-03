local constants = require("builtin.utils.constants")

require("illuminate").configure({
    -- delay: delay in milliseconds
    delay = 500,
    -- disable cursor word for big file
    large_file_cutoff = constants.perf.file.maxsize,
})

-- highlight style
vim.cmd([[
augroup vim_illuminate_augroup
    autocmd!
    autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
augroup END
]])