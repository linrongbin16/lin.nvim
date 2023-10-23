local neoconf = require("neoconf")

require("illuminate").configure({
    -- delay: delay in milliseconds
    delay = 500,
    -- disable cursor word for big file
    large_file_cutoff = neoconf.get("linopts.perf.maxfilesize"),
})

-- highlight style
vim.cmd([[
augroup vim_illuminate_augroup
    autocmd!
    autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
augroup END
]])
