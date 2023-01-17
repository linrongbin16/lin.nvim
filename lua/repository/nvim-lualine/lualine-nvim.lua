local function LinGitStatus()
    local branch = vim.b.gitsigns_head
    if branch == nil or branch == '' then
        return ''
    end
    local changes = vim.b.gitsigns_status
    if changes == nil or changes == '' then
        return string.format(' %s', branch)
    else
        return string.format(' %s %s', branch, changes)
    end
end

local function LinRtrim(s)
    local n = #s
    while n > 0 and s:find("^%s", n) do n = n - 1 end
    return s:sub(1, n)
end

local function LinLspStatus()
    if #vim.lsp.buf_get_clients() > 0 then
        return LinRtrim(require('lsp-status').status())
    end
    return ''
end

local DiagnosticSigns = {
    { 'errors', vim.g.lin_constants.lsp.diagnostic_signs['error'] },
    { 'warnings', vim.g.lin_constants.lsp.diagnostic_signs['warning'] },
    { 'info', vim.g.lin_constants.lsp.diagnostic_signs['info'] },
    { 'hints', vim.g.lin_constants.lsp.diagnostic_signs['hint'] },
}
local function LinLspDiagnostics()
    if #vim.lsp.buf_get_clients() > 0 then
        local diags = require('lsp-status').diagnostics()
        if diags ~= nil then
            local messages = {}
            -- local msg = {}
            for i, sign in ipairs(DiagnosticSigns) do
                local name = sign[1]
                local icon = sign[2]
                -- print('i:', i, ', name:', name, ', icon:', icon, ', diags[name]:', diags[name])
                if diags[name] and diags[name] > 0 then
                    table.insert(messages, string.format('%s %d', icon, diags[name]))
                end
            end
            -- print(table.concat(msg, ","))
            if #messages > 0 then
                return table.concat(messages, " ")
            else
                return ''
            end
        end
    end
    return ''
end

local function LinLspCurrentFunction()
    local current_function = vim.b.lsp_current_function
    if current_function and current_function ~= '' then
        return string.format(' %s', current_function)
    end
    return ''
end

local function LinCursorPosition()
    return ' %3l:%-2v'
end

local function LinCursorHex()
    return '0x%02B'
end

local function LinTagsStatus()
    if not vim.fn.exists('*gutentags#statusline') then
        return ''
    end
    local tags_status = vim.fn['gutentags#statusline']()
    if tags_status == nil or tags_status == '' then
        return ''
    end
    return tags_status
end

local config = {
    options = {
        icons_enabled = true,
        -- theme = 'auto',
        -- component_separators = {'', ''},
        -- section_separators = {'', ''},
        disabled_filetypes = {},
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filename' },
        lualine_c = { LinGitStatus, LinLspDiagnostics, LinLspCurrentFunction, LinLspStatus, LinTagsStatus },
        lualine_x = { LinCursorHex, 'filetype', 'fileformat', 'encoding' },
        lualine_y = { 'progress' },
        lualine_z = { LinCursorPosition },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}

require('lualine').setup(config)
