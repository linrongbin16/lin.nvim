-- ---- LSP ----

local constants = require("builtin.utils.constants")
local set_key = require("builtin.utils.keymap").set_key

-- hover/signatureHelp
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = constants.ui.border })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = constants.ui.border }
)

vim.api.nvim_create_augroup("builtin_lsp_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = "builtin_lsp_augroup",
    callback = function()
        local function make_desc(value)
            return { buffer = true, desc = value }
        end

        --- @param next boolean
        --- @param severity integer?
        local function diagnostic_goto(next, severity)
            local go = next and vim.diagnostic.goto_next
                or vim.diagnostic.goto_prev
            return function()
                go({ severity = severity })
            end
        end

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
        set_key("n", "gd", definition_cmd, make_desc("Go to lsp definitions"))

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
            make_desc("Go to lsp type definitions")
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
            make_desc("Go to lsp implementations")
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
        set_key("n", "gr", reference_cmd, make_desc("Go to lsp references"))

        set_key(
            "n",
            "gD",
            "<cmd>lua vim.lsp.buf.declaration()<cr>",
            make_desc("Go to declarations")
        )
        set_key(
            "n",
            "<leader>ic",
            "<cmd>lua vim.lsp.buf.incoming_calls()<cr>",
            make_desc("Go to incoming calls")
        )
        set_key(
            "n",
            "<leader>og",
            "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>",
            make_desc("Go to outgoing calls")
        )

        -- hover
        set_key(
            "n",
            "K",
            "<cmd>lua vim.lsp.buf.hover()<cr>",
            make_desc("Show hover")
        )

        set_key(
            { "n", "i" },
            "<C-k>",
            "<cmd>lua vim.lsp.buf.signature_help()<cr>",
            make_desc("Show signature help")
        )

        -- operation
        set_key(
            "n",
            "<Leader>rn",
            "<cmd>lua vim.lsp.buf.rename()<cr>",
            make_desc("Rename symbol")
        )
        set_key(
            "n",
            "<Leader>ca",
            "<cmd>lua vim.lsp.buf.code_action()<cr>",
            make_desc("Code actions")
        )
        set_key(
            "x",
            "<Leader>ca",
            "<cmd>lua vim.lsp.buf.range_code_action()<cr>",
            make_desc("Code actions")
        )

        -- diagnostic
        set_key(
            "n",
            "]d",
            diagnostic_goto(true),
            make_desc("Next diagnostic item")
        )
        set_key(
            "n",
            "[d",
            diagnostic_goto(false),
            make_desc("Previous diagnostic item")
        )
        set_key(
            "n",
            "]e",
            diagnostic_goto(true, vim.diagnostic.severity.ERROR),
            make_desc("Next diagnostic error")
        )
        set_key(
            "n",
            "[e",
            diagnostic_goto(false, vim.diagnostic.severity.ERROR),
            make_desc("Previous diagnostic error")
        )
        set_key(
            "n",
            "]w",
            diagnostic_goto(true, vim.diagnostic.severity.WARN),
            make_desc("Next diagnostic warning")
        )
        set_key(
            "n",
            "[w",
            diagnostic_goto(false, vim.diagnostic.severity.WARN),
            make_desc("Previous diagnostic warning")
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

local function setup_diagnostic()
    local highlights = {
        DiagnosticError = { "ErrorMsg", "#ff0000" },
        DiagnosticWarn = { "WarningMsg", "#FFFF00" },
        DiagnosticInfo = { "Normal", "#00FFFF" },
        DiagnosticHint = { "Comment", "#808080" },
        DiagnosticOk = { "Normal", "#008000" },
    }
    for name, hl in pairs(highlights) do
        local old_hl = vim.api.nvim_get_hl(0, { name = name })
        if type(old_hl) ~= "table" or vim.tbl_isempty(old_hl) then
            local new_hl = vim.api.nvim_get_hl(0, { name = hl[1] })
            if type(new_hl) == "table" and not vim.tbl_isempty(new_hl) then
                vim.api.nvim_set_hl(0, name, { link = hl[1] })
            else
                vim.api.nvim_set_hl(0, name, { fg = hl[2] })
            end
        end
    end

    vim.diagnostic.config({
        virtual_text = false,
        severity_sort = true,
        float = {
            border = constants.ui.border,
            source = "always",
            header = "",
            prefix = "",
        },
    })

    local signs = {
        DiagnosticSignError = constants.diagnostic.sign.error,
        DiagnosticSignWarn = constants.diagnostic.sign.warning,
        DiagnosticSignInfo = constants.diagnostic.sign.info,
        DiagnosticSignHint = constants.diagnostic.sign.hint,
        DiagnosticSignOk = constants.diagnostic.sign.ok,
    }

    for name, text in pairs(signs) do
        vim.fn.sign_define(name, {
            texthl = name,
            text = text,
            numhl = "",
        })
    end
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = "builtin_lsp_augroup",
    callback = vim.schedule_wrap(setup_diagnostic),
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = "builtin_lsp_augroup",
    callback = vim.schedule_wrap(setup_diagnostic),
})
