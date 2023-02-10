-- ---- Lsp settings ----

local constants = require("conf/constants")

-- key mappings
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function()
        local bufmap = function(mode, lhs, rhs)
            local opts = { buffer = true, noremap = true, silent = true }
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- navigation
        if vim.fn.exists(":Glance") > 0 then
            bufmap("n", "gd", "<CMD>Glance definitions<CR>")
            bufmap("n", "gt", "<CMD>Glance type_definitions<CR>")
            bufmap("n", "gi", "<CMD>Glance implementations<CR>")
            bufmap("n", "gr", "<CMD>Glance references<CR>")
        else
            bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
            bufmap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
            bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
            bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
        end
        bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
        bufmap("n", "gI", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>")
        bufmap("n", "gO", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>")

        -- hover
        bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
        bufmap({ "n", "i" }, "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")

        -- operation
        bufmap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
        bufmap({ "n", "x" }, "<Leader>cf", "<cmd>lua vim.lsp.buf.format({async=false})<cr>")
        bufmap("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
        bufmap("x", "<Leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<cr>")

        -- diagnostic
        local function diagnostic_goto(next, severity)
            local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
            severity = severity and vim.diagnostic.severity[severity] or nil
            return function()
                go({ severity = severity })
            end
        end
        bufmap("n", "<Leader>dc", "<cmd>lua vim.diagnostic.open_float()<cr>")
        bufmap("n", "]d", diagnostic_goto(true))
        bufmap("n", "[d", diagnostic_goto(false))
        bufmap("n", "]e", diagnostic_goto(true, "ERROR"))
        bufmap("n", "[e", diagnostic_goto(false, "ERROR"))
        bufmap("n", "]w", diagnostic_goto(true, "WARN"))
        bufmap("n", "[w", diagnostic_goto(false, "WARN"))
    end,
})

-- diagnostic signs
local setDiagnosticSign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
    })
end

setDiagnosticSign({ name = "DiagnosticSignError", text = constants.lsp.diagnostics.signs["error"] })
setDiagnosticSign({ name = "DiagnosticSignWarn", text = constants.lsp.diagnostics.signs["warning"] })
setDiagnosticSign({ name = "DiagnosticSignInfo", text = constants.lsp.diagnostics.signs["info"] })
setDiagnosticSign({ name = "DiagnosticSignHint", text = constants.lsp.diagnostics.signs["hint"] })

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

-- hover/signatureHelp
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = constants.ui.border })
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = constants.ui.border })
