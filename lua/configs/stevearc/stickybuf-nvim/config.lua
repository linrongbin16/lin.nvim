require("stickybuf").setup()

vim.api.nvim_create_augroup("stickybuf_augroup", { clear = true })
vim.schedule(function()
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
        group = "stickybuf_augroup",
        callback = function()
            vim.schedule(function()
                local bufnrs_list = vim.api.nvim_list_bufs()
                local bufnrs_count = 0
                if type(bufnrs_list) == "table" then
                    for _, bufnr in ipairs(bufnrs_list) do
                        if not require("stickybuf").should_auto_pin(bufnr) then
                            bufnrs_count = bufnrs_count + 1
                        end
                    end
                end
                if type(bufnrs_list) == "table" then
                    for i, bufnr in ipairs(bufnrs_list) do
                        local bufname = vim.api.nvim_buf_get_name(bufnr)
                        if string.len(bufname) == 0 and bufnrs_count > 2 then
                            vim.api.nvim_buf_delete(bufnr, {})
                        end
                    end
                end
            end)
        end,
    })
end)
