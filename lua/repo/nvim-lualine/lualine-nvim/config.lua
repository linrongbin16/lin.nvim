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

-- local function LspStatusProgress()
--     if #vim.lsp.buf_get_clients() > 0 then
--         return Rtrim(require("lsp-status").status())
--     end
--     return ""
-- end

local function CursorLocation()
    return " %3l:%-2v"
end

local function CursorHex()
    return "0x%04B"
end

local function TagsStatus()
    if not vim.fn.exists("*gutentags#statusline") then
        return ""
    end
    local stats = vim.fn["gutentags#statusline"]()
    if stats == nil or stats == "" then
        return ""
    end
    return stats
end

local function SearchStatus()
    if vim.v.hlsearch == 0 then
        return ""
    end
    local lastsearch = vim.fn.getreg("/")
    if not lastsearch or lastsearch == "" then
        return ""
    end
    local searchcount = vim.fn.searchcount({ maxcount = 9999 })
    return lastsearch .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
end

local constants = require("conf/constants")

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
        lualine_b = { "branch", "diff" },
        lualine_c = {
            "filename",
            require("lsp-progress").progress,
            TagsStatus,
        },
        lualine_x = {
            SearchStatus,
            {
                "diagnostics",
                symbols = {
                    error = constants.lsp.diagnostics.signs["error"] .. " ",
                    warn = constants.lsp.diagnostics.signs["warning"] .. " ",
                    info = constants.lsp.diagnostics.signs["info"] .. " ",
                    hint = constants.lsp.diagnostics.signs["hint"] .. " ",
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
        lualine_y = { "progress" },
        lualine_z = { CursorLocation },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
}

require("lualine").setup(config)

-- listen to lsp-progress event and trigger refresh
vim.cmd([[
augroup lualine_augroup
    autocmd!
    autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
augroup END
]])
