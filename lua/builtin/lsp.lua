-- ---- LSP ----

local constants = require("builtin.utils.constants")
local set_key = require("builtin.utils.keymap").set_key

-- diagnostics
vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    float = {
        border = constants.ui.border,
        source = "always",
        header = "",
        prefix = "",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = constants.diagnostic.sign.error,
            [vim.diagnostic.severity.WARN] = constants.diagnostic.sign.warning,
            [vim.diagnostic.severity.INFO] = constants.diagnostic.sign.info,
            [vim.diagnostic.severity.HINT] = constants.diagnostic.sign.hint,
        },
    },
})

local diagnostic_hls = {
    DiagnosticError = "ErrorMsg",
    DiagnosticWarn = "WarningMsg",
    DiagnosticInfo = "Normal",
    DiagnosticHint = "Comment",
    DiagnosticSignError = "DiagnosticError",
    DiagnosticSignWarn = "DiagnosticWarn",
    DiagnosticSignInfo = "DiagnosticInfo",
    DiagnosticSignHint = "DiagnosticHint",
}

for name, link in pairs(diagnostic_hls) do
    local hl = vim.api.nvim_get_hl(0, { name = name })
    if hl == nil or vim.tbl_isempty(hl) then
        vim.api.nvim_set_hl(0, name, { link = link })
    end
end

-- hover/signatureHelp
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = constants.ui.border })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = constants.ui.border }
)

-- key mapping
--- @param value string
--- @return table<any, any>
local function map_desc(value)
    return { buffer = true, desc = value }
end

--- @param next boolean
--- @param severity string|nil
local function diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity ~= nil and vim.diagnostic.severity[severity] --[[@as string]]
        or nil
    return function()
        go({ severity = severity })
    end
end

vim.api.nvim_create_augroup("builtin_lsp_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = "builtin_lsp_augroup",
    callback = function()
        -- lsp key mappings
        -- navigation

        -- definitions
        local definition_cmd = nil
        if vim.fn.exists(":FzfxLspDefinitions") > 0 then
            definition_cmd = "<CMD>FzfxLspDefinitions<CR>"
        elseif vim.fn.exists(":Glance") > 0 then
            definition_cmd = "<CMD>Glance definitions<CR>"
        else
            definition_cmd = "<cmd>lua vim.lsp.buf.definition()<cr>"
        end
        set_key("n", "gd", definition_cmd, map_desc("Go to lsp definitions"))

        -- type definitions
        local type_definition_cmd = nil
        if vim.fn.exists(":FzfxLspTypeDefinitions") > 0 then
            type_definition_cmd = "<CMD>FzfxLspTypeDefinitions<CR>"
        elseif vim.fn.exists(":Glance") > 0 then
            type_definition_cmd = "<CMD>Glance type_definitions<CR>"
        else
            type_definition_cmd = "<cmd>lua vim.lsp.buf.type_definition()<cr>"
        end
        set_key(
            "n",
            "gt",
            type_definition_cmd,
            map_desc("Go to lsp type definitions")
        )

        -- implementations
        local implementation_cmd = nil
        if vim.fn.exists(":FzfxLspImplementations") > 0 then
            implementation_cmd = "<CMD>FzfxLspImplementations<CR>"
        elseif vim.fn.exists(":Glance") > 0 then
            implementation_cmd = "<CMD>Glance implementations<CR>"
        else
            implementation_cmd = "<cmd>lua vim.lsp.buf.implementation()<cr>"
        end
        set_key(
            "n",
            "gi",
            implementation_cmd,
            map_desc("Go to lsp implementations")
        )

        -- references
        local reference_cmd = nil
        if vim.fn.exists(":FzfxLspReferences") > 0 then
            reference_cmd = "<CMD>FzfxLspReferences<CR>"
        elseif vim.fn.exists(":Glance") > 0 then
            reference_cmd = "<CMD>Glance references<CR>"
        else
            reference_cmd = "<cmd>lua vim.lsp.buf.references()<cr>"
        end
        set_key("n", "gr", reference_cmd, map_desc("Go to lsp references"))

        set_key(
            "n",
            "gD",
            "<cmd>lua vim.lsp.buf.declaration()<cr>",
            map_desc("Go to declarations")
        )
        set_key(
            "n",
            "<leader>ic",
            "<cmd>lua vim.lsp.buf.incoming_calls()<cr>",
            map_desc("Go to incoming calls")
        )
        set_key(
            "n",
            "<leader>og",
            "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>",
            map_desc("Go to outgoing calls")
        )

        -- hover
        set_key(
            "n",
            "K",
            "<cmd>lua vim.lsp.buf.hover()<cr>",
            map_desc("Show hover")
        )

        set_key(
            { "n", "i" },
            "<C-k>",
            "<cmd>lua vim.lsp.buf.signature_help()<cr>",
            map_desc("Show signature help")
        )

        -- operation
        set_key(
            "n",
            "<Leader>rn",
            "<cmd>lua vim.lsp.buf.rename()<cr>",
            map_desc("Rename symbol")
        )
        -- don't format via lsp.
        -- use conform.nvim, see: /lua/configs/stevearc/conform-nvim/keys.lua.
        --
        -- set_key(
        --     { "n", "x" },
        --     "<Leader>cf",
        --     "<cmd>lua vim.lsp.buf.format({async=false})<cr>",
        --     map_desc("Code format")
        -- )
        set_key(
            "n",
            "<Leader>ca",
            "<cmd>lua vim.lsp.buf.code_action()<cr>",
            map_desc("Code actions")
        )
        set_key(
            "x",
            "<Leader>ca",
            "<cmd>lua vim.lsp.buf.range_code_action()<cr>",
            map_desc("Code actions")
        )

        -- diagnostic
        set_key(
            "n",
            "]d",
            diagnostic_goto(true),
            map_desc("Next diagnostic item")
        )
        set_key(
            "n",
            "[d",
            diagnostic_goto(false),
            map_desc("Previous diagnostic item")
        )
        set_key(
            "n",
            "]e",
            diagnostic_goto(true, "ERROR"),
            map_desc("Next diagnostic error")
        )
        set_key(
            "n",
            "[e",
            diagnostic_goto(false, "ERROR"),
            map_desc("Previous diagnostic error")
        )
        set_key(
            "n",
            "]w",
            diagnostic_goto(true, "WARN"),
            map_desc("Next diagnostic warning")
        )
        set_key(
            "n",
            "[w",
            diagnostic_goto(false, "WARN"),
            map_desc("Previous diagnostic warning")
        )

        -- switch header/source for c/c++
        set_key(
            "n",
            "<leader>sw",
            ":ClangdSwitchSourceHeader<CR>",
            { silent = false, desc = "Switch between c/c++ header and source" }
        )

        -- (silently) detach lsp client when close buffer
        -- for better lsp performance
        -- vim.api.nvim_create_autocmd("BufDelete", {
        --     buffer = vim.api.nvim_get_current_buf(),
        --     callback = function(opts)
        --         local bufnr = opts.buf
        --         local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        --         for client_id, _ in pairs(clients) do
        --             -- quietly without warning
        --             vim.cmd(
        --                 string.format(
        --                     "silent lua vim.lsp.buf_detach_client(%d,%d)",
        --                     bufnr,
        --                     client_id
        --                 )
        --             )
        --         end
        --     end,
        -- })

        -- disable tagfunc to fix workspace/symbol not support error
        vim.bo.tagfunc = nil
    end,
})
