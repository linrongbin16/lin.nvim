local function GitDiffCondition()
    return vim.fn.exists("*GitGutterGetHunkSummary") > 0
end

local function GitDiffSource()
    local changes = vim.fn.GitGutterGetHunkSummary() or {}
    return {
        added = changes[1] or 0,
        modified = changes[2] or 0,
        removed = changes[3] or 0,
    }
end

local function Search()
    if vim.v.hlsearch == 0 then
        return ""
    end
    local lastsearch = vim.fn.getreg("/")
    if not lastsearch or lastsearch == "" then
        return ""
    end
    local searchcount = vim.fn.searchcount({ maxcount = 100 })
    return lastsearch
        .. "("
        .. searchcount.current
        .. "/"
        .. searchcount.total
        .. ")"
end

local function Location()
    return " %l:%v"
end

local constants = require("builtin.utils.constants")

local empty_component_separators = { left = "", right = "" }

-- style-1: A > B > C ---- X < Y < Z
local angle_component_separators = { left = "", right = "" }
local angle_section_separators = { left = "", right = "" }

-- style-2: A \ B \ C ---- X / Y / Z
local slash_component_separators = { left = "", right = "" }
local slash_section_separators = { left = "", right = "" }

local config = {
    options = {
        icons_enabled = true,
        component_separators = empty_component_separators,
        section_separators = slash_section_separators,
        refresh = {
            statusline = 3000,
            tabline = 10000,
            winbar = 10000,
        },
    },
    sections = {
        lualine_a = {
            "mode",
        },
        lualine_b = {
            "branch",
            {
                "diff",
                cond = GitDiffCondition,
                source = GitDiffSource,
                padding = { left = 0, right = 1 },
            },
        },
        lualine_c = {
            { "filename", file_status = true },
            require("lsp-progress").progress,
        },
        lualine_x = {
            Search,
            {
                "diagnostics",
                symbols = {
                    error = constants.diagnostic.sign.error .. " ",
                    warn = constants.diagnostic.sign.warning .. " ",
                    info = constants.diagnostic.sign.info .. " ",
                    hint = constants.diagnostic.sign.hint .. " ",
                },
            },
            "filetype",
            {
                "fileformat",
                symbols = {
                    unix = " LF", -- e712
                    dos = " CRLF", -- e70f
                    mac = " CR", -- e711
                },
            },
            "encoding",
        },
        lualine_y = { Location },
        lualine_z = { "progress" },
    },
    inactive_sections = {},
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
}

require("lualine").setup(config)

-- listen to lsp-progress event and refresh
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = { "LspProgressStatusUpdated", "GitGutter" },
    callback = function()
        require("lualine").refresh({
            place = { "statusline" },
        })
    end,
})
