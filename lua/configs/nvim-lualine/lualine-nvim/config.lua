local constants = require("builtin.utils.constants")

local function GetHl(...)
    for _, name in ipairs({ ... }) do
        if vim.fn.hlexists(name) > 0 then
            local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
            if type(hl) == "table" and hl.fg ~= nil then
                return tostring(hl.fg)
            end
        end
    end
    return nil
end

local function OsName()
    if constants.os.is_windows then
        return ""
    elseif constants.os.is_macos then
        return ""
    else
        return "󰣠"
    end
end

local function FileSize()
    local file = vim.fn.expand("%:p")
    if file == nil or #file == 0 then
        return ""
    end
    local size = vim.fn.getfsize(file)
    if size <= 0 then
        return ""
    end

    local suffixes = { "b", "k", "m", "g" }

    local i = 1
    while size > 1024 and i < #suffixes do
        size = size / 1024
        i = i + 1
    end

    local format = i == 1 and "[%d%s]" or "[%.1f%s]"
    return string.format(format, size, suffixes[i])
end

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

local function LspStatus()
    local status = require("lsp-progress").progress()
    return type(status) == "string" and string.len(status) > 0 and status or ""
end

local function Location()
    return " %3l:%-2v"
end
local function Progress()
    local bar = " "
    local line_fraction = math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)
    if line_fraction >= 100 then
        return bar .. "Bot "
    elseif line_fraction <= 0 then
        return bar .. "Top "
    else
        return string.format("%s%2d%%%% ", bar, line_fraction)
    end
end

-- local SCROLL_BAR = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
--
-- local function ScrollBar()
--     local curr_line = vim.api.nvim_win_get_cursor(0)[1]
--     local lines = vim.api.nvim_buf_line_count(0)
--     local i = math.floor((curr_line - 1) / lines * #SCROLL_BAR) + 1
--     return string.rep(SCROLL_BAR[i], 2)
-- end
--
-- local ScrollBarColor = GetHl(
--     "LuaLineDiffDelete",
--     "GitSignsDelete",
--     "GitGutterDelete",
--     "DiffRemoved",
--     "DiffDelete"
-- ) or "#ff0038"

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
            OsName,
            { "mode", padding = { left = 0, right = 1 } },
        },
        lualine_b = {
            "branch",
        },
        lualine_c = {
            {
                "filename",
                file_status = true,
                path = constants.os.is_windows and 0 or 4,
                symbols = {
                    modified = "[]", -- Text to show when the file is modified.
                    readonly = "[]", -- Text to show when the file is non-modifiable or readonly.
                    unnamed = "[No Name]", -- Text to show for unnamed buffers.
                    newfile = "[New]", -- Text to show for newly created file before first write
                },
            },
            { FileSize, padding = { left = 0, right = 1 } },
            {
                "diff",
                cond = GitDiffCondition,
                source = GitDiffSource,
                padding = { left = 1, right = 1 },
            },
            LspStatus,
        },
        lualine_x = {
            { "searchcount", maxcount = 100, timeout = 300 },
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
        },
        lualine_y = {
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
        lualine_z = {
            { Location, padding = { left = 1, right = 0 } },
            { Progress, padding = { left = 1, right = 0 } },
        },
    },
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
