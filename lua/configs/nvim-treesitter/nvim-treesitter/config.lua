local constants = require("builtin.utils.constants")

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "html",
        "javascript",
        "typescript",
        "tsx",
    },
    auto_install = false,
    matchup = { -- for vim-matchup
        enable = true,
    },
    autotag = { -- for nvim-ts-autotag
        enable = true,
        filetypes = {
            "html",
            "xml",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "jsx",
            "tsx",
            "svelte",
            "vue",
            "rescript",
            "css",
            "php",
            "markdown",
        },
    },
    highlight = {
        enable = true,
        -- disable for super large file
        disable = function(lang, buf)
            local max_filesize = constants.perf.file.maxsize
            local ok, stats =
                pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        additional_vim_regex_highlighting = false,
    },
})