-- local function GitStatus()
--     local branch = vim.fn["gitbranch#name"]()
--     if branch == nil or branch == "" then
--         return ""
--     end
--     local changes = vim.fn["GitGutterGetHunkSummary"]()
--     if changes == nil or #changes ~= 3 then
--         return string.format(" %s", branch)
--     else
--         local added = changes[1]
--         local modified = changes[2]
--         local removed = changes[3]
--         local msg = {}
--         if added > 0 then
--             table.insert(msg, string.format("+%d", added))
--         end
--         if modified > 0 then
--             table.insert(msg, string.format("~%d", modified))
--         end
--         if removed > 0 then
--             table.insert(msg, string.format("-%d", removed))
--         end
--         if #msg > 0 then
--             return string.format(" %s %s", branch, table.concat(msg, " "))
--         else
--             return string.format(" %s", branch)
--         end
--     end
-- end

-- local function Rtrim(s)
--     local n = #s
--     while n > 0 and s:find("^%s", n) do
--         n = n - 1
--     end
--     return s:sub(1, n)
-- end

local function GitDiff()
    if vim.g.loaded_gitgutter <= 0 then
        return ""
    end
    local changes = vim.fn["GitGutterGetHunkSummary"]()
    if changes == nil or #changes ~= 3 then
        return ""
    end
    -- added, modified, removed
    local signs = { "+", "~", "-" }
    local msg = {}
    for i = 1, 3 do
        if changes[i] > 0 then
            table.insert(msg, signs[i] .. changes[i])
        end
    end
    return #msg > 0 and table.concat(msg, " ") or ""
end

local function Modifiable()
    return (vim.bo.modifiable == false or vim.bo.readonly == true) and "[RO]"
        or ""
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

local function LspSign()
    return require("lsp-progress").progress({
        format = function(messages)
            return " LSP"
        end,
    })
end

local function MatchUpOrLspStatus()
    if vim.g.loaded_matchup > 0 then
        local status = vim.fn["MatchupStatusOffscreen"]()
        if status ~= nil and string.len(status) > 0 then
            return "Δ " .. status
        end
    end
    local builder = {}
    local lsp = require("lsp-progress").progress({
        format = function(messages)
            return #messages > 0 and table.concat(messages, " ") or ""
        end,
    })
    if lsp ~= nil and string.len(lsp) > 0 then
        table.insert(builder, lsp)
    end
    local tags = Ctags()
    if tags ~= nil and string.len(tags) > 0 then
        table.insert(builder, tags)
    end
    return #builder > 0 and table.concat(builder, " ") or ""
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

local function Location()
    return " %3l:%-2v"
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
            LspSign,
            MatchUpOrLspStatus,
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
