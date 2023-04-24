local function on_attach(client, bufnr)
    -- attach navic to work with multiple tabs
    if client.server_capabilities["documentSymbolProvider"] then
        require("nvim-navic").attach(client, bufnr)
    end
    -- async code format
    require("lspformatter").on_attach(client, bufnr)
    -- disable tagfunc to fix workspace/symbol not support error
    vim.bo.tagfunc = nil
end

local M = {
    on_attach = on_attach,
}

return M