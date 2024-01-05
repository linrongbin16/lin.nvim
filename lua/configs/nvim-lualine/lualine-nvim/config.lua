local constants = require("builtin.utils.constants")

local function OsName()
    if constants.os.is_windows then
        return ""
    elseif constants.os.is_macos then
        return ""
    else
        return "󰣠"
    end
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

local function Location()
    return " %l:%-2v"
end

local SCROLL_BAR = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }

local function ScrollBar()
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #SCROLL_BAR) + 1
    return string.rep(SCROLL_BAR[i], 2)
end

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
            {
                "diff",
                cond = GitDiffCondition,
                source = GitDiffSource,
                padding = { left = 0, right = 1 },
            },
        },
        lualine_c = {
            { "filename", file_status = true, path = 4 },
            require("lsp-progress").progress,
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
        lualine_z = {
            "progress",
            {
                ScrollBar,
                color = function()
                    local mode = vim.o.termguicolors and "gui" or "cterm"
                    local code = vim.fn.synIDattr(
                        vim.fn.synIDtrans(vim.fn.hlID("Special")),
                        "fg",
                        mode
                    )
                    return { fg = code, gui = "bold" }
                end,
            },
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
