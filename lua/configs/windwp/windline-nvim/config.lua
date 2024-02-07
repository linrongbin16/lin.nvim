local windline = require("windline")
local helper = require("windline.helpers")
local sep = helper.separators
local HSL = require("wlanimation.utils")

local cache_utils = require("windline.cache_utils")

local colors_hl = require("commons.colors.hl")
local strings = require("commons.strings")
local tables = require("commons.tables")
local uv = require("commons.uv")
local constants = require("builtin.utils.constants")

-- slant_left = '',
-- slant_right = '',
local LEFT_SEP = sep.slant_left
local RIGHT_SEP = sep.slant_right

local state = _G.WindLine.state

-- color utils {
local function GetModeName()
    return state.mode[1]
end

--- @param with_sep boolean?
local function GetHl(with_sep)
    return with_sep and state.mode[2] .. "Sep" or state.mode[2]
end

local function ModifyColor(c, value)
    if vim.o.background == "light" then
        return HSL.rgb_to_hsl(c):tint(value):to_rgb()
    end
    return HSL.rgb_to_hsl(c):shade(value):to_rgb()
end
-- color utils }

-- highlight constants {
local Highlight1 = {
    NormalSep = { "magenta_a", "magenta_b" },
    InsertSep = { "green_a", "magenta_b" },
    VisualSep = { "yellow_a", "magenta_b" },
    ReplaceSep = { "blue_a", "magenta_b" },
    CommandSep = { "red_a", "magenta_b" },
    Normal = { "black", "magenta_a" },
    Insert = { "black", "green_a" },
    Visual = { "black", "yellow_a" },
    Replace = { "black", "blue_a" },
    Command = { "black", "red_a" },
}

local Highlight2 = {
    NormalSep = { "magenta_b", "magenta_c" },
    Normal = { "white", "magenta_b" },
    Insert = { "white", "magenta_b" },
    Visual = { "white", "magenta_b" },
    Replace = { "white", "magenta_b" },
    Command = { "white", "magenta_b" },
}

local Highlight3 = {
    NormalSep = { "magenta_c", "magenta_d" },
    Normal = { "white", "magenta_c" },
}

local Highlight4 = {
    NormalSep = { "magenta_d", "black" },
    Normal = { "white", "magenta_d" },
    GitAdd = { "diff_add", "magenta_d" },
    GitDelete = { "diff_delete", "magenta_d" },
    GitChange = { "diff_change", "magenta_d" },
    DiagnosticError = { "diagnostic_error", "magenta_d" },
    DiagnosticWarn = { "diagnostic_warn", "magenta_d" },
    DiagnosticInfo = { "diagnostic_info", "magenta_d" },
    DiagnosticHint = { "diagnostic_hint", "magenta_d" },
}

local WIDTH_BREAKPOINT = 70

local DividerComponent = { "%=", Highlight4.Normal }

local OS_UNAME = uv.os_uname()

local function GetOsIcon()
    local uname = OS_UNAME.sysname
    if uname == "Darwin" then
        return ""
    elseif uname == "Linux" then
        if
            type(OS_UNAME.release) == "string" and OS_UNAME.release:find("arch")
        then
            return ""
        end
        return ""
    elseif uname == "Windows" then
        return ""
    else
        return "󱚟"
    end
end

local Mode = {
    name = "mode",
    hl_colors = Highlight1,
    text = function(_, _, width)
        local os_icon = GetOsIcon()
        if width > WIDTH_BREAKPOINT then
            return {
                {
                    " " .. os_icon .. " " .. GetModeName() .. " ",
                    GetHl(),
                },
                { RIGHT_SEP, GetHl(true) },
            }
        end
        return {
            {
                " " .. os_icon .. " " .. GetModeName():sub(1, 1) .. " ",
                GetHl(),
            },
            { RIGHT_SEP, GetHl(true) },
        }
    end,
}

local GitBranch = {
    name = "git_branch",
    hl_colors = Highlight2,
    text = function(bufnr, _, width)
        if width > WIDTH_BREAKPOINT then
            local has_git_branch = vim.fn.exists("*gitbranch#name") > 0
            if has_git_branch then
                local git_branch = vim.fn["gitbranch#name"]()
                if strings.not_empty(git_branch) then
                    return {
                        { " ", GetHl() },
                        { " " .. git_branch .. " ", "Normal" },
                        { RIGHT_SEP, "NormalSep" },
                    }
                end
            end
        end
        return { { " ", GetHl() }, { RIGHT_SEP, "NormalSep" } }
    end,
}

local function GetFileName(bufnr, _, width)
    local default = "[No Name]"
    local filepath = vim.fn.expand("%:p")
    if strings.empty(filepath) then
        return default
    end
    local filename = vim.fn.fnamemodify(filepath, ":t")
    return filename
end

local FileName = {
    name = "file_name",
    hl_colors = Highlight3,
    text = function()
        return {
            { " ", "Normal" },
            {
                cache_utils.cache_on_buffer(
                    { "BufEnter", "BufNewFile" },
                    "WindLineComponent_FileName",
                    GetFileName
                ),
            },
            { " " },
        }
    end,
}

local function GetFileStatus(bufnr, _, width)
    local filepath = vim.fn.expand("%:p")
    if strings.empty(filepath) then
        return ""
    end

    local filestatus = ""
    local readonly = not vim.api.nvim_buf_get_option(bufnr, "modifiable")
        or vim.api.nvim_buf_get_option(bufnr, "readonly")
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    if readonly then
        filestatus = "[]"
    elseif modified then
        filestatus = "[]"
    end

    local fsize = vim.fn.getfsize(filepath)
    if fsize <= 0 then
        return filestatus
    end
    local suffixes = { "b", "k", "m", "g" }
    local i = 1
    while fsize > 1024 and i < #suffixes do
        fsize = fsize / 1024
        i = i + 1
    end

    local filesize_format = i == 1 and "[%d%s]" or "[%.1f%s]"
    local filesize = string.format(filesize_format, fsize, suffixes[i])
    if string.len(filestatus) > 0 then
        return filestatus .. " " .. filesize
    else
        return filesize
    end
end

local FileStatus = {
    name = "file_status",
    hl_colors = Highlight3,
    width = WIDTH_BREAKPOINT,
    text = function()
        return {
            {
                cache_utils.cache_on_buffer({
                    "BufEnter",
                    "WinEnter",
                    "TextChangedI",
                    "BufWritePost",
                }, "WindLineComponent_FileStatus", GetFileStatus),
            },
            { " " },
            { RIGHT_SEP, "NormalSep" },
        }
    end,
}

local function GetGitDiff()
    if vim.fn.exists("*GitGutterGetHunkSummary") > 0 then
        local summary = vim.fn["GitGutterGetHunkSummary"]()
        local signs = { "+", "~", "-" }
        local hls = { "GitAdd", "GitChange", "GitDelete" }
        local components = { { " ", "Normal" } }
        local found = false
        for i = 1, 3 do
            local value = summary[i] or 0
            if value > 0 then
                table.insert(
                    components,
                    { string.format("%s%d ", signs[i], value), hls[i] }
                )
                found = true
            end
        end
        if found then
            return components
        end
    end
    return { { " ", "Normal" } }
end

local GitDiff = {
    name = "git_diff",
    width = WIDTH_BREAKPOINT,
    hl_colors = Highlight4,
    text = cache_utils.cache_on_buffer(
        { "User GitGutter" },
        "WindLineComponent_GitDiff",
        GetGitDiff
    ),
}

local function GetDiagnostics(bufnr)
    local signs = {
        constants.diagnostic.sign.error,
        constants.diagnostic.sign.warn,
        constants.diagnostic.sign.info,
        constants.diagnostic.sign.hint,
    }
    local hls = {
        "DiagnosticError",
        "DiagnosticWarn",
        "DiagnosticInfo",
        "DiagnosticHint",
    }
    local severity = { "ERROR", "WARN", "INFO", "HINT" }
    local components = {}
    local space = false
    for i, name in ipairs(severity) do
        local count = #vim.diagnostic.get(
            bufnr,
            { severity = vim.diagnostic.severity[name] }
        )
        if count > 0 then
            if space then
                table.insert(
                    components,
                    { " " .. signs[i] .. " " .. tostring(count), hls[i] }
                )
            else
                space = true
                table.insert(
                    components,
                    { signs[i] .. " " .. tostring(count), hls[i] }
                )
            end
        end
    end

    table.insert(components, { " ", "Normal" })
    return components
end

local SearchCount = {
    name = "search_count",
    hl_colors = Highlight4,
    width = WIDTH_BREAKPOINT,
    text = function(bufnr)
        if vim.v.hlsearch == 0 then
            return ""
        end

        local MAX_COUNT = 99
        local ok, result = pcall(vim.fn.searchcount, { maxcount = MAX_COUNT })
        if not ok or type(result) ~= "table" or result.current == nil then
            return ""
        end

        if result.incomplete == 1 then -- timed out
            return " [?/??] "
        end

        local current_fmt = "%d"
        local total_fmt = "%d"
        if result.incomplete == 2 then -- max count exceeded
            if result.total > MAX_COUNT and result.current > MAX_COUNT then
                current_fmt = ">%d"
                total_fmt = ">%d"
            elseif result.total > MAX_COUNT then
                total_fmt = ">%d"
            end
        end
        return string.format(
            " [" .. current_fmt .. "/" .. total_fmt .. "] ",
            result.current or 0,
            result.total or 0
        )
    end,
}

local Diagnostic = {
    name = "diagnostic",
    hl_colors = Highlight4,
    text = cache_utils.cache_on_buffer(
        { "DiagnosticChanged", "BufEnter", "BufWritePost" },
        "WindLineComponent_Diagnostic",
        GetDiagnostics
    ),
}

local function GetFileTypeIcon(bufnr)
    local unknown_file = ""
    local file_name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
    if strings.empty(file_name) then
        return ""
    end
    local file_ext = vim.fn.fnamemodify(file_name, ":e")
    local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
    local icon_text
    local icon_color
    if devicons_ok and devicons ~= nil then
        icon_text, icon_color = devicons.get_icon_color(file_name, file_ext)
        if strings.empty(icon_text) then
            icon_text = unknown_file
            icon_color = nil
        end
    end
    return {
        { LEFT_SEP, "NormalSep" },
        { " ", "Normal" },
        { icon_text },
        { " " },
    }
end

local FileTypeIcon = {
    name = "file_type_icon",
    hl_colors = Highlight3,
    text = cache_utils.cache_on_buffer(
        { "BufEnter", "BufReadPre", "BufNewFile" },
        "WindLineComponent_FileTypeIcon",
        GetFileTypeIcon
    ),
}

local function GetFileType(bufnr)
    local file_name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
    if strings.empty(file_name) then
        return {
            { LEFT_SEP, "NormalSep" },
            { " ", "Normal" },
        }
    end
    local file_ext = vim.fn.fnamemodify(file_name, ":e")
    if strings.empty(file_ext) then
        return {
            { LEFT_SEP, "NormalSep" },
            { " ", "Normal" },
        }
    end
    local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
    local unknown_icon = ""
    local icon_text
    local icon_color
    if devicons_ok and devicons ~= nil then
        icon_text, icon_color = devicons.get_icon_color(file_name, file_ext)
        if strings.empty(icon_text) then
            icon_text = unknown_icon
            icon_color = nil
        end
    end
    return {
        { LEFT_SEP, "NormalSep" },
        { " ", "Normal" },
        { icon_text .. " " .. file_ext, "Normal" },
        { " " },
    }
end

local FileType = {
    name = "file_type",
    hl_colors = Highlight3,
    text = cache_utils.cache_on_buffer(
        { "BufEnter", "BufReadPre", "BufNewFile" },
        "WindLineComponent_FileType",
        GetFileType
    ),
}

local FileEncodingIcon = {
    ["utf-8"] = "󰉿",
    ["utf-16"] = "󰊀",
    ["utf-32"] = "󰊁",
    ["utf-8mb4"] = "󰊂",
    ["utf-16le"] = "󰊃",
    ["utf-16be"] = "󰊄",
}

local function GetFileEncoding(bufnr)
    local encoding = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
    local encoding_icon = FileEncodingIcon[encoding]
    if strings.not_empty(encoding_icon) then
        encoding = encoding_icon .. " " .. encoding
    end

    return {
        { LEFT_SEP, "NormalSep" },
        { " ", "Normal" },
        { encoding },
        { " " },
    }
end

local FileEncoding = {
    name = "file_encoding",
    hl_colors = Highlight2,
    text = cache_utils.cache_on_buffer(
        { "BufEnter", "BufNewFile", "BufReadPost" },
        "WindLineComponent_FileEncoding",
        GetFileEncoding
    ),
}

local FileFormatIcon = {
    unix = "", -- e712
    dos = "", -- e70f
    mac = "", -- e711
}

local function GetFileFormat()
    local format = vim.bo.fileformat
    local format_icon = FileFormatIcon[format]
    if strings.not_empty(format_icon) then
        format = format_icon .. " " .. format
    end

    return {
        { format, "Normal" },
        { " " },
    }
end

local FileFormat = {
    name = "file_format",
    hl_colors = Highlight2,
    text = cache_utils.cache_on_buffer(
        { "BufEnter", "BufNewFile", "BufReadPost" },
        "WindLineComponent_FileFormat",
        GetFileFormat
    ),
}

local Location = {
    name = "location",
    hl_colors = Highlight1,
    text = function(_, winnr)
        local row, col = unpack(vim.api.nvim_win_get_cursor(winnr))
        return {
            { LEFT_SEP, GetHl(true) },
            { " ", GetHl() },
            { string.format(" %3s:%2s ", row, col + 1) },
        }
    end,
}

local Progress = {
    name = "progress",
    hl_colors = Highlight1,
    text = function()
        local line_fraction =
            math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)
        local value = string.format("%3d%%%%", line_fraction)
        if line_fraction <= 0 then
            value = "Top"
        elseif line_fraction >= 100 then
            value = "Bot"
        end
        return {
            { " ", GetHl() },
            { value },
            { " " },
        }
    end,
}

-- local quickfix = {
--     filetypes = { "qf", "Trouble" },
--     active = {
--         { "🚦 Quickfix ", { "white", "black" } },
--         { helper.separators.slant_right, { "black", "black_light" } },
--         {
--             function()
--                 return vim.fn.getqflist({ title = 0 }).title
--             end,
--             { "cyan", "black_light" },
--         },
--         { " Total : %L ", { "cyan", "black_light" } },
--         { helper.separators.slant_right, { "black_light", "InactiveBg" } },
--         { " ", { "InactiveFg", "InactiveBg" } },
--         DividerComponent,
--         { helper.separators.slant_right, { "InactiveBg", "black" } },
--         { "🧛 ", { "white", "black" } },
--     },
--     always_active = true,
--     show_last_status = true,
-- }

local default = {
    filetypes = { "default" },
    active = {
        Mode,
        GitBranch,
        FileName,
        FileStatus,
        GitDiff,
        DividerComponent,
        SearchCount,
        Diagnostic,
        -- FileTypeIcon,
        FileType,
        FileEncoding,
        FileFormat,
        Location,
        Progress,
    },
    inactive = {},
}

windline.setup({
    colors_name = function(colors)
        local DiffAddColor = colors_hl.get_color_with_fallback(
            { "GitSignsAdd", "GitGutterAdd", "diffAdded", "DiffAdd" },
            "fg",
            "#008000"
        )
        local DiffChangeColor = colors_hl.get_color_with_fallback(
            { "GitSignsChange", "GitGutterChange", "diffChanged", "DiffChange" },
            "fg",
            "#FFFF00"
        )
        local DiffDeleteColor = colors_hl.get_color_with_fallback(
            { "GitSignsDelete", "GitGutterDelete", "diffRemoved", "DiffDelete" },
            "fg",
            "#FF0000"
        )
        local DiagnosticErrorColor = colors_hl.get_color_with_fallback(
            { "DiagnosticSignError", "LspDiagnosticsSignError", "ErrorMsg" },
            "fg",
            "#FF0000"
        )
        local DiagnosticWarnColor = colors_hl.get_color_with_fallback(
            { "DiagnosticSignWarn", "LspDiagnosticsSignWarn", "WarningMsg" },
            "fg",
            "#FFFF00"
        )
        local DiagnosticInfoColor = colors_hl.get_color_with_fallback(
            { "DiagnosticSignInfo", "LspDiagnosticsSignInfo", "None" },
            "fg",
            "#008000"
        )
        local DiagnosticHintColor = colors_hl.get_color_with_fallback(
            { "DiagnosticSignHint", "LspDiagnosticsSignHint", "Comment" },
            "fg",
            "#00FFFF"
        )

        colors.diff_add = DiffAddColor
        colors.diff_change = DiffChangeColor
        colors.diff_delete = DiffDeleteColor
        colors.diagnostic_error = DiagnosticErrorColor
        colors.diagnostic_warn = DiagnosticWarnColor
        colors.diagnostic_info = DiagnosticInfoColor
        colors.diagnostic_hint = DiagnosticHintColor

        local BlackColor = -- "#000000"
            colors_hl.get_color_with_fallback({ "Normal" }, "bg", "#000000")
        local WhiteColor = -- "#ffffff"
            colors_hl.get_color_with_fallback({ "Normal" }, "fg", "#ffffff")

        colors.black = BlackColor
        colors.white = WhiteColor

        local lualine_ok, lualine_theme = pcall(
            require,
            string.format("lualine.themes.%s", vim.g.colors_name)
        )
        if lualine_ok and type(lualine_theme) == "table" then
            if
                strings.not_empty(
                    tables.tbl_get(lualine_theme, "normal", "a", "bg")
                )
            then
                colors.magenta = lualine_theme.normal.a.bg
            end
            if
                strings.not_empty(
                    tables.tbl_get(lualine_theme, "normal", "a", "fg")
                )
            then
                colors.black = lualine_theme.normal.a.fg
            end
            if
                strings.not_empty(
                    tables.tbl_get(lualine_theme, "insert", "a", "bg")
                )
            then
                colors.green = lualine_theme.insert.a.bg
            end
            if
                strings.not_empty(
                    tables.tbl_get(lualine_theme, "visual", "a", "bg")
                )
            then
                colors.yellow = lualine_theme.visual.a.bg
            end
            if
                strings.not_empty(
                    tables.tbl_get(lualine_theme, "replace", "a", "bg")
                )
            then
                colors.blue = lualine_theme.replace.a.bg
            end
            if
                strings.not_empty(
                    tables.tbl_get(lualine_theme, "command", "a", "bg")
                )
            then
                colors.red = lualine_theme.command.a.bg
            end
        end

        colors.magenta_a = colors.magenta
        colors.magenta_b = ModifyColor(colors.magenta, 0.5)
        colors.magenta_c = ModifyColor(colors.magenta, 0.6)
        colors.magenta_d = ModifyColor(colors.magenta, 0.7)

        colors.yellow_a = colors.yellow
        colors.blue_a = colors.blue
        colors.green_a = colors.green
        colors.red_a = colors.red

        return colors
    end,
    statuslines = {
        default,
        -- quickfix,
    },
})
