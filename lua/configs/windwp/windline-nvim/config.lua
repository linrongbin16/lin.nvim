local windline = require("windline")
local helper = require("windline.helpers")
local sep = helper.separators
local HSL = require("wlanimation.utils")

local cache_utils = require("windline.cache_utils")

local colors_hl = require("commons.colors.hl")
local strings = require("commons.strings")
local uv = require("commons.uv")
local constants = require("builtin.utils.constants")

-- slant_left = '',
-- slant_right = '',
local LEFT_SEP = sep.slant_left
local RIGHT_SEP = sep.slant_right

local state = _G.WindLine.state

local contrast_threshold = 0.3
local brightness_modifier_parameter = 10

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

-- Turns #rrggbb -> { red, green, blue }
local function rgb_str2num(rgb_color_str)
    if rgb_color_str:find("#") == 1 then
        rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
    end
    local red = tonumber(rgb_color_str:sub(1, 2), 16)
    local green = tonumber(rgb_color_str:sub(3, 4), 16)
    local blue = tonumber(rgb_color_str:sub(5, 6), 16)
    return { red = red, green = green, blue = blue }
end

-- Turns { red, green, blue } -> #rrggbb
local function rgb_num2str(rgb_color_num)
    local rgb_color_str = string.format(
        "#%02x%02x%02x",
        rgb_color_num.red,
        rgb_color_num.green,
        rgb_color_num.blue
    )
    return rgb_color_str
end

local function get_color_brightness(rgb_color)
    local color = rgb_str2num(rgb_color)
    local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
    return brightness / 256
end

-- Clamps the val between left and right
local function clamp(val, left, right)
    if val > right then
        return right
    end
    if val < left then
        return left
    end
    return val
end

-- Changes brightness of rgb_color by percentage
local function brightness_modifier(rgb_color, percentage)
    local color = rgb_str2num(rgb_color)
    color.red = clamp(color.red + (color.red * percentage / 100), 0, 255)
    color.green = clamp(color.green + (color.green * percentage / 100), 0, 255)
    color.blue = clamp(color.blue + (color.blue * percentage / 100), 0, 255)
    return rgb_num2str(color)
end

-- Changes contrast of rgb_color by amount
local function contrast_modifier(rgb_color, amount)
    local color = rgb_str2num(rgb_color)
    color.red = clamp(color.red + amount, 0, 255)
    color.green = clamp(color.green + amount, 0, 255)
    color.blue = clamp(color.blue + amount, 0, 255)
    return rgb_num2str(color)
end

-- returns average of colors in range 0 to 1
-- used to determine contrast level
local function get_color_avg(rgb_color)
    local color = rgb_str2num(rgb_color)
    return (color.red + color.green + color.blue) / 3 / 256
end

-- Changes brightness of foreground color to achieve contrast
-- without changing the color
local function apply_contrast(highlight)
    local highlight_bg_avg = get_color_avg(highlight.bg)
    local contrast_threshold_config = clamp(contrast_threshold, 0, 0.5)
    local contrast_change_step = 5
    if highlight_bg_avg > 0.5 then
        contrast_change_step = -contrast_change_step
    end

    -- Don't waste too much time here max 25 iteration should be more than enough
    local iteration_count = 1
    while
        math.abs(get_color_avg(highlight.fg) - highlight_bg_avg)
            < contrast_threshold_config
        and iteration_count < 25
    do
        highlight.fg = contrast_modifier(highlight.fg, contrast_change_step)
        iteration_count = iteration_count + 1
    end
end
-- color utils }

-- color constants {
local BlackColor = -- "#000000"
    colors_hl.get_color_with_fallback({ "Normal" }, "bg", "#000000")
local WhiteColor = -- "#ffffff"
    colors_hl.get_color_with_fallback({ "Normal" }, "fg", "#ffffff")
local NormalBgColor = colors_hl.get_color_with_fallback(
    { "PmenuSel", "PmenuThumb", "TabLineSel" },
    "bg",
    vim.g.terminal_color_5 -- magenta
)
local InsertBgColor = colors_hl.get_color_with_fallback(
    { "String", "MoreMsg" },
    "fg",
    vim.g.terminal_color_2 -- green
)
local ReplaceBgColor = colors_hl.get_color_with_fallback(
    { "Number", "Type" },
    "fg",
    vim.g.terminal_color_4 -- blue
)
local VisualBgColor = colors_hl.get_color_with_fallback(
    { "Special", "Boolean", "Constant" },
    "fg",
    vim.g.terminal_color_3 -- yellow
)
local CommandBgColor = colors_hl.get_color_with_fallback(
    { "Identifier" },
    "fg",
    vim.g.terminal_color_1 -- red
)

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
-- color constants }

-- highlight constants {
local Highlight1 = {
    NormalSep = { "normal_bg1", "normal_bg2" },
    InsertSep = { "insert_bg1", "normal_bg2" },
    VisualSep = { "visual_bg1", "normal_bg2" },
    ReplaceSep = { "replace_bg1", "normal_bg2" },
    CommandSep = { "command_bg1", "normal_bg2" },
    Normal = { "white", "normal_bg1" },
    Insert = { "black", "insert_bg1" },
    Visual = { "black", "visual_bg1" },
    Replace = { "black", "replace_bg1" },
    Command = { "black", "command_bg1" },
}

local Highlight2 = {
    NormalSep = { "normal_bg2", "normal_bg3" },
    Normal = { "white", "normal_bg2" },
    Insert = { "white", "normal_bg2" },
    Visual = { "white", "normal_bg2" },
    Replace = { "white", "normal_bg2" },
    Command = { "white", "normal_bg2" },
}

local Highlight3 = {
    NormalSep = { "normal_bg3", "normal_bg4" },
    Normal = { "white", "normal_bg3" },
}

local Highlight4 = {
    NormalSep = { "normal_bg4", "black" },
    Normal = { "white", "normal_bg4" },
    GitAdd = { "diff_add", "normal_bg4" },
    GitDelete = { "diff_delete", "normal_bg4" },
    GitChange = { "diff_change", "normal_bg4" },
    DiagnosticError = { "diagnostic_error", "normal_bg4" },
    DiagnosticWarn = { "diagnostic_warn", "normal_bg4" },
    DiagnosticInfo = { "diagnostic_info", "normal_bg4" },
    DiagnosticHint = { "diagnostic_hint", "normal_bg4" },
}
-- highlight constants {

if NormalBgColor then
    if get_color_brightness(NormalBgColor) > 0.5 then
        brightness_modifier_parameter = -brightness_modifier_parameter
        Highlight1.Normal[1] = "black"
    end

    NormalBgColor =
        brightness_modifier(NormalBgColor, brightness_modifier_parameter)
    InsertBgColor =
        brightness_modifier(InsertBgColor, brightness_modifier_parameter)
    ReplaceBgColor =
        brightness_modifier(ReplaceBgColor, brightness_modifier_parameter)
    VisualBgColor =
        brightness_modifier(VisualBgColor, brightness_modifier_parameter)
    CommandBgColor =
        brightness_modifier(CommandBgColor, brightness_modifier_parameter)
end

local NormalBgColor1 = NormalBgColor
local NormalBgColor2 = ModifyColor(NormalBgColor1, 0.5)
local NormalBgColor3 = ModifyColor(NormalBgColor1, 0.6)
local NormalBgColor4 = ModifyColor(NormalBgColor1, 0.7)
local InsertBgColor1 = InsertBgColor
-- local InsertBgColor2 = ModifyColor(InsertBgColor1, 0.5)
-- local InsertBgColor3 = ModifyColor(InsertBgColor1, 0.7)
local VisualBgColor1 = VisualBgColor
-- local VisualBgColor2 = ModifyColor(VisualBgColor1, 0.5)
-- local VisualBgColor3 = ModifyColor(VisualBgColor1, 0.7)
local ReplaceBgColor1 = ReplaceBgColor
-- local ReplaceBgColor2 = ModifyColor(ReplaceBgColor1, 0.5)
-- local ReplaceBgColor3 = ModifyColor(ReplaceBgColor1, 0.7)
local CommandBgColor1 = CommandBgColor
-- local CommandBgColor2 = ModifyColor(CommandBgColor1, 0.5)
-- local CommandBgColor3 = ModifyColor(CommandBgColor1, 0.7)

local HighlightBuilder1 = {
    NormalSep = { fg = NormalBgColor1, bg = NormalBgColor2 },
    InsertSep = { fg = InsertBgColor1, bg = NormalBgColor2 },
    VisualSep = { fg = VisualBgColor1, bg = NormalBgColor2 },
    ReplaceSep = { fg = ReplaceBgColor1, bg = NormalBgColor2 },
    CommandSep = { fg = CommandBgColor1, bg = NormalBgColor2 },
    Normal = { fg = BlackColor, bg = NormalBgColor1 },
    Insert = { fg = BlackColor, bg = InsertBgColor1 },
    Visual = { fg = BlackColor, bg = VisualBgColor1 },
    Replace = { fg = BlackColor, bg = ReplaceBgColor1 },
    Command = { fg = BlackColor, bg = CommandBgColor1 },
}

local HighlightBuilder2 = {
    NormalSep = { fg = NormalBgColor2, bg = NormalBgColor3 },
    Normal = { fg = WhiteColor, bg = NormalBgColor2 },
    Insert = { fg = WhiteColor, bg = NormalBgColor2 },
    Visual = { fg = WhiteColor, bg = NormalBgColor2 },
    Replace = { fg = WhiteColor, bg = NormalBgColor2 },
    Command = { fg = WhiteColor, bg = NormalBgColor2 },
}

local HighlightBuilder3 = {
    NormalSep = { fg = NormalBgColor3, bg = NormalBgColor4 },
    Normal = { fg = WhiteColor, bg = NormalBgColor3 },
}

local HighlightBuilder4 = {
    NormalSep = { fg = NormalBgColor4, bg = BlackColor },
    Normal = { fg = WhiteColor, bg = NormalBgColor4 },
    GitAdd = { fg = DiffAddColor, bg = NormalBgColor4 },
    GitDelete = { fg = DiffDeleteColor, bg = NormalBgColor4 },
    GitChange = { fg = DiffChangeColor, bg = NormalBgColor4 },
    DiagnosticError = { fg = DiagnosticErrorColor, bg = NormalBgColor4 },
    DiagnosticWarn = { fg = DiagnosticWarnColor, bg = NormalBgColor4 },
    DiagnosticInfo = { fg = DiagnosticInfoColor, bg = NormalBgColor4 },
    DiagnosticHint = { fg = DiagnosticHintColor, bg = NormalBgColor4 },
}

for _, h in ipairs(HighlightBuilder1) do
    apply_contrast(h)
end
for _, h in ipairs(HighlightBuilder2) do
    apply_contrast(h)
end
for _, h in ipairs(HighlightBuilder3) do
    apply_contrast(h)
end
for _, h in ipairs(HighlightBuilder4) do
    apply_contrast(h)
end

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
        constants.diagnostic.sign.hint,
        constants.diagnostic.sign.info,
        constants.diagnostic.sign.warn,
        constants.diagnostic.sign.error,
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
        colors.black = HighlightBuilder1.Normal.fg
        colors.white = HighlightBuilder4.Normal.fg

        colors.normal_bg1 = HighlightBuilder1.Normal.bg
        colors.normal_bg2 = HighlightBuilder2.Normal.bg
        colors.normal_bg3 = HighlightBuilder3.Normal.bg
        colors.normal_bg4 = HighlightBuilder4.Normal.bg
        colors.insert_bg1 = HighlightBuilder1.Insert.bg
        colors.replace_bg1 = HighlightBuilder1.Replace.bg
        colors.visual_bg1 = HighlightBuilder1.Visual.bg
        colors.command_bg1 = HighlightBuilder1.Command.bg

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

        colors.magenta_a = colors.magenta
        colors.magenta_b = ModifyColor(colors.magenta, 0.5)
        colors.magenta_c = ModifyColor(colors.magenta, 0.7)

        colors.yellow_a = colors.yellow
        colors.yellow_b = ModifyColor(colors.yellow, 0.5)
        colors.yellow_c = ModifyColor(colors.yellow, 0.7)

        colors.blue_a = colors.blue
        colors.blue_b = ModifyColor(colors.blue, 0.5)
        colors.blue_c = ModifyColor(colors.blue, 0.7)

        colors.green_a = colors.green
        colors.green_b = ModifyColor(colors.green, 0.5)
        colors.green_c = ModifyColor(colors.green, 0.7)

        colors.red_a = colors.red
        colors.red_b = ModifyColor(colors.red, 0.5)
        colors.red_c = ModifyColor(colors.red, 0.7)

        return colors
    end,
    statuslines = {
        default,
        -- quickfix,
    },
})
