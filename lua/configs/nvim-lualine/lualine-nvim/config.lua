local function GitDiff()
    if vim.g.loaded_gitgutter <= 0 then
        -- return { added = 0, modified = 0, removed = 0 }
        return {}
    end
    local changes = vim.fn["GitGutterGetHunkSummary"]()
    if changes == nil or #changes ~= 3 then
        -- return { added = 0, modified = 0, removed = 0 }
        return {}
    end
    return { added = changes[1], modified = changes[2], removed = changes[3] }
    -- -- added, modified, removed
    -- local signs = { "+", "~", "-" }
    -- local msg = {}
    -- for i = 1, 3 do
    --     if changes[i] > 0 then
    --         table.insert(msg, signs[i] .. changes[i])
    --     end
    -- end
    -- return #msg > 0 and table.concat(msg, " ") or ""
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

local constants = require("builtin.utils.constants")

local empty_component_separators = { left = "", right = "" }

-- style-1: A > B > C ---- X < Y < Z
local angle_component_separators = { left = "", right = "" }
local angle_section_separators = { left = "", right = "" }

-- style-2: A \ B \ C ---- X / Y / Z
local slash_component_separators = { left = "", right = "" } -- nf-ple-backslash_separator \ue0b9, nf-ple-forwardslash_separator \ue0bb
local slash_section_separators = { left = "", right = "" }

local config = {
    options = {
        icons_enabled = true,
        component_separators = empty_component_separators,
        section_separators = slash_section_separators,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            "branch",
            {
                "diff",
                source = GitDiff, -- A function that works as a data source for diff.
            },
        },
        lualine_c = {
            "filename",
            {
                "diagnostics",
                symbols = {
                    error = constants.diagnostic.sign.error .. " ",
                    warn = constants.diagnostic.sign.warning .. " ",
                    info = constants.diagnostic.sign.info .. " ",
                    hint = constants.diagnostic.sign.hint .. " ",
                },
            },
            require("lsp-progress").progress,
            -- Ctags,
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
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})
