lua << END
local function LinLuaLineGitStatus()
    local branch=vim.b.gitsigns_head
    if branch == nil or branch == '' then
        return ''
    end
    local changes=vim.b.gitsigns_status
    if changes == nil or changes == '' then
        return string.format(' %s', branch)
    else
        return string.format(' %s %s', branch, changes)
    end
end
local function LinLuaLineLspStatus()
    if not vim.fn.exists('*coc#status') then
        return ''
    end
    local coc_status = vim.fn['coc#status']()
    if coc_status == nil or coc_status == '' then
        return ''
    else
        return coc_status
    end
end
local function LinLuaLineCursorPosition()
    return ' %3l:%-2v'
end
local function LinLuaLineCursorHexValue()
    return '0x%B'
end
local function LinLuaLineGutentagsStatus()
    if not vim.fn.exists('*gutentags#statusline') then
        return ''
    end
    local tags_status = vim.fn['gutentags#statusline']()
    if tags_status == nil or tags_status == '' then
        return ''
    end
    return tags_status
end
require('lualine').setup{
    options = {
        icons_enabled = false,
        -- theme = 'auto',
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        -- disabled_filetypes = {'NvimTree'},
        -- always_divide_middle = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filename' },
        lualine_c = { LinLuaLineGitStatus, LinLuaLineLspStatus, LinLuaLineGutentagsStatus },
        lualine_x = { 'fileformat', 'encoding', 'filetype', LinLuaLineCursorHexValue },
        lualine_y = { 'progress' },
        lualine_z = { LinLuaLineCursorPosition },
    },
    inactive_secions = {}
    -- tabline = {},
    -- winbar = {},
    -- inactive_winbar = {},
    -- extensions = {}
}
END
