-- ---- Colorschemes ----

local colornames = {
    "deus",
    "moonfly",
    "nightfly",
    "catppuccin",
    "challenger_deep",
    "iceberg",
    "dracula",
    "palenight",
    "nightfox",
    "gruvbox",
    "embark",
    "falcon",
    "tokyonight",
    "tender",
    "zenburn",
    "seoul256",
    "solarized8",
    "xcode",
    "material",
    "OceanicNext",
    "onedark",
    "PaperColor",
    "oxocarbon",
    "spaceduck",
    "pencil",
    "github_dark",
    "one",
    "lucario",
    "kanagawa",
    "apprentice",
    "rose-pine",
    "edge",
    "everforest",
    "gruvbox-material",
    "sonokai",
    "nord",
    "monokai",
    "srcery",
    "codedark",
}

math.randomseed(os.clock() * 100000000000)

local function randint()
    return math.random(1, #colornames)
end

--- Switch to next color
--- @param option table<string, any>
local function switch_color(option)
    if type(option.args) == "string" and string.len(option.args) > 0 then
        vim.cmd.colorscheme(option.args)
    else
        vim.cmd.colorscheme(colornames[randint()])
    end
    if option.bang ~= nil and option.bang then
        if vim.fn.has("diff") > 0 then
            vim.cmd([[ diffupdate ]])
        end
        vim.cmd([[ syntax sync fromstart ]])
    end
end

vim.api.nvim_create_user_command("SwitchColor", switch_color, {
    bang = true,
    nargs = "?",
    complete = "color",
    desc = "Switch to next {color}",
})