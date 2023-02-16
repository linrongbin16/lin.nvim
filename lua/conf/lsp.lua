-- ---- Lsp settings ----

local constants = require("conf/constants")

-- diagnostic signs
local diagnosticSign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
    })
end

diagnosticSign({
    name = "DiagnosticSignError",
    text = constants.lsp.diagnostics.signs["error"],
})
diagnosticSign({
    name = "DiagnosticSignWarn",
    text = constants.lsp.diagnostics.signs["warning"],
})
diagnosticSign({
    name = "DiagnosticSignInfo",
    text = constants.lsp.diagnostics.signs["info"],
})
diagnosticSign({
    name = "DiagnosticSignHint",
    text = constants.lsp.diagnostics.signs["hint"],
})

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
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = constants.ui.border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = constants.ui.border }
)

-- key mappings
local function diagnosticGoto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

vim.api.nvim_create_augroup("lsp_attach_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = "lsp_attach_augroup",
    callback = function()
        local map = require("conf/keymap").map
        local opts = { buffer = true }

        -- navigation
        if vim.fn.exists(":Glance") > 0 then
            map("n", "gd", "<CMD>Glance definitions<CR>")
            map("n", "gt", "<CMD>Glance type_definitions<CR>")
            map("n", "gi", "<CMD>Glance implementations<CR>")
            map("n", "gr", "<CMD>Glance references<CR>")
        else
            map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
            map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
            map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
            map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
        end
        map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
        map("n", "<leader>ic", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>")
        map("n", "<leader>og", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>")

        -- hover
        map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
        map({ "n", "i" }, "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")

        -- operation
        map("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
        map(
            { "n", "x" },
            "<Leader>cf",
            "<cmd>lua vim.lsp.buf.format({async=false})<cr>"
        )
        map("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
        map("x", "<Leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<cr>")

        -- diagnostic
        map("n", "<Leader>dc", "<cmd>lua vim.diagnostic.open_float()<cr>")
        map("n", "]d", diagnosticGoto(true))
        map("n", "[d", diagnosticGoto(false))
        map("n", "]e", diagnosticGoto(true, "ERROR"))
        map("n", "[e", diagnosticGoto(false, "ERROR"))
        map("n", "]w", diagnosticGoto(true, "WARN"))
        map("n", "[w", diagnosticGoto(false, "WARN"))

        -- detach lsp client when after buffer
        vim.api.nvim_create_autocmd("BufDelete", {
            buffer = vim.api.nvim_get_current_buf(),
            callback = function(opts)
                local bufnr = opts.buf
                local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
                for client_id, _ in pairs(clients) do
                    -- quietly without warning
                    vim.cmd(
                        string.format(
                            "silent lua vim.lsp.buf_detach_client(%d,%d)",
                            bufnr,
                            client_id
                        )
                    )
                end
            end,
        })
    end,
})
