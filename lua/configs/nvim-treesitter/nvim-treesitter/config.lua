local constants = require("builtin.utils.constants")
local message = require("builtin.utils.message")

local ensure_installed = {
    "vim",
    "lua",
    "html",
    "javascript",
    "typescript",
    "tsx",
}

local user_ensure_installed_module =
    "configs.nvim-treesitter.nvim-treesitter.ensure-installed"
local user_ensure_installed_ok, user_ensure_installed =
    pcall(require, user_ensure_installed_module)
if user_ensure_installed_ok then
    if type(user_ensure_installed) == "table" then
        ensure_installed = user_ensure_installed
    else
        message.warn(
            string.format(
                "Error loading '%s' lua module!",
                user_ensure_installed_module
            )
        )
    end
end

require("nvim-treesitter.configs").setup({
    ensure_installed = ensure_installed,
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