-- local function Rtrim(s)
--     local n = #s
--     while n > 0 and s:find("^%s", n) do
--         n = n - 1
--     end
--     return s:sub(1, n)
-- end

local function GitDiff()
    -- added, modified, removed
    local signs = { "+", "~", "-" }
    local msg = {}
    if vim.g.loaded_gitgutter and vim.g.loaded_gitgutter > 0 then
        local changes = vim.fn["GitGutterGetHunkSummary"]()
        if changes == nil or #changes ~= 3 then
            return ""
        end
        for i = 1, 3 do
            if changes[i] > 0 then
                table.insert(msg, signs[i] .. changes[i])
            end
        end
    end
    if
        vim.b.gitsigns_status_dict
        and type(vim.b.gitsigns_status_dict) == "table"
    then
        local signkeys = { "added", "changed", "removed" }
        for i = 1, 3 do
            local value = vim.b.gitsigns_status_dict[signkeys[i]]
            if value and value > 0 then
                table.insert(msg, signs[i] .. value)
            end
        end
    end
    return #msg > 0 and table.concat(msg, " ") or ""
end

local function Modifiable()
    return (vim.bo.modifiable == false or vim.bo.readonly == true) and "[RO]"
        or ""
end

local function Location()
    return " %3l:%-2v"
end

-- local function CursorHex()
--     return "0x%04B"
-- end

local function Ctags()
    if vim.g.loaded_gutentags <= 0 then
        return ""
    end
    local stats = vim.fn["gutentags#statusline"]()
    return (stats == nil or stats == "") and "" or stats
end

local function Search()
    if vim.v.hlsearch == 0 then
        return ""
    end
    local lastsearch = vim.fn.getreg("/")
    if not lastsearch or lastsearch == "" then
        return ""
    end
    local searchcount = vim.fn.searchcount({ maxcount = 9999 })
    return lastsearch
        .. "("
        .. searchcount.current
        .. "/"
        .. searchcount.total
        .. ")"
end

local const = require("cfg.const")

local config = {
    options = {
        icons_enabled = true,
        -- theme = 'auto',

        -- style-1: A > B > C ---- X < Y < Z
        -- component_separators = {'', ''},
        -- section_separators = {'', ''},

        -- style-2: A \ B \ C ---- X / Y / Z
        component_separators = {
            -- left = "", -- nf-ple-backslash_separator \ue0b9
            -- right = "", -- nf-ple-forwardslash_separator \ue0bb
            left = "",
            right = "",
        },
        section_separators = {
            left = "",
            right = "",
        },
        disabled_filetypes = {},
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", GitDiff },
        lualine_c = {
            -- "filename",
            Modifiable,
            {
                "diagnostics",
                symbols = {
                    error = const.lsp.diagnostics.signs["error"] .. " ",
                    warn = const.lsp.diagnostics.signs["warning"] .. " ",
                    info = const.lsp.diagnostics.signs["info"] .. " ",
                    hint = const.lsp.diagnostics.signs["hint"] .. " ",
                },
            },
            require("lsp-progress").progress,
            Ctags,
        },
        lualine_x = {
            Search,
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
        lualine_y = { "progress" },
        lualine_z = { Location },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { Modifiable },
        lualine_x = { Location },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
}

require("lualine").setup(config)

-- listen to lsp-progress event and refresh
vim.cmd([[
augroup lualine_augroup
    autocmd!
    autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
augroup END
]])