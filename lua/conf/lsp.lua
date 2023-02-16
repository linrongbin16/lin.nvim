-- ---- Lsp settings ----

local constants = require("conf/constants")
local map = require("conf/keymap").map

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

local function make_desc(desc)
    return { buffer = true, desc = desc }
end

vim.api.nvim_create_augroup("lsp_attach_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = "lsp_attach_augroup",
    callback = function()
        -- navigation
        if vim.fn.exists(":Glance") > 0 then
            map(
                "n",
                "gd",
                "<CMD>Glance definitions<CR>",
                make_desc("Go to definitions"),
            )
            map(
                "n",
                "gt",
                "<CMD>Glance type_definitions<CR>",
                make_desc("Go to type definitions"),
            )
            map(
                "n",
                "gi",
                "<CMD>Glance implementations<CR>",
                make_desc("Go to implementations"),
            )
            map(
                "n",
                "gr",
                "<CMD>Glance references<CR>",
                make_desc("Go to references"),
            )
        else
            map(
                "n",
                "gd",
                "<cmd>lua vim.lsp.buf.definition()<cr>",
                make_desc("Go to definitions"),
            )
            map(
                "n",
                "gt",
                "<cmd>lua vim.lsp.buf.type_definition()<cr>",
                make_desc("Go to type definitions"),
            )
            map(
                "n",
                "gi",
                "<cmd>lua vim.lsp.buf.implementation()<cr>",
                make_desc("Go to implementations"),
            )
            map(
                "n",
                "gr",
                "<cmd>lua vim.lsp.buf.references()<cr>",
                make_desc("Go to references"),
            )
        end
        map(
            "n",
            "gD",
            "<cmd>lua vim.lsp.buf.declaration()<cr>",
            make_desc("Go to declarations"),
        )
        map(
            "n",
            "<leader>ic",
            "<cmd>lua vim.lsp.buf.incoming_calls()<cr>",
            make_desc("Go to incoming calls"),
        )
        map(
            "n",
            "<leader>og",
            "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>",
            make_desc("Go to outgoing calls"),
        )

        -- hover
        map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", make_desc("Show hover"))

        map({ "n", "i" }, "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", make_desc("Show signature help"))

        -- operation
        map("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", make_desc("Rename symbol"))
        map(
            { "n", "x" },
            "<Leader>cf",
            "<cmd>lua vim.lsp.buf.format({async=false})<cr>", make_desc("Code format")
        )
        map("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", make_desc("Code actions"))
        map("x", "<Leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<cr>", make_desc("Code actions"))

        -- diagnostic
        map("n", "<Leader>dc", "<cmd>lua vim.diagnostic.open_float()<cr>", make_desc("Show diagnostic under cursor"))
        map("n", "]d", diagnosticGoto(true), make_desc("Next diagnostic item"))
        map("n", "[d", diagnosticGoto(false), make_desc("Previous diagnostic item"))
        map("n", "]e", diagnosticGoto(true, "ERROR"), make_desc("Next diagnostic error"))
        map("n", "[e", diagnosticGoto(false, "ERROR"), make_desc("Previous diagnostic error"))
        map("n", "]w", diagnosticGoto(true, "WARN"), make_desc("Next diagnostic warning"))
        map("n", "[w", diagnosticGoto(false, "WARN"), make_desc("Previous diagnostic warning"))

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

map(
    "n",
    "<F4>",
    ":ClangdSwitchSourceHeader<CR>",
    { silent = false, desc = "Switch between c/c++ header and source" }
)
