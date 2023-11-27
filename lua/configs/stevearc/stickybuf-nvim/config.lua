require("stickybuf").setup()

vim.api.nvim_create_augroup("stickybuf_augroup", { clear = true })
vim.schedule(function()
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
        group = "stickybuf_augroup",
        callback = function()
            vim.schedule(function()
                local bufnrs = vim.api.nvim_list_bufs()
                local bufs_count = 0
                local del_count = 0
                local del_bufs = {}
                if type(bufnrs) == "table" then
                    for _, bufnr in ipairs(bufnrs) do
                        local bufname = vim.api.nvim_buf_get_name(bufnr)
                        if not require("stickybuf").should_auto_pin(bufnr) then
                            bufs_count = bufs_count + 1
                        end
                        if string.len(bufname) == 0 then
                            del_count = del_count + 1
                            table.insert(del_bufs, bufnr)
                        end
                    end
                end
                if bufs_count > del_count + 1 then
                    for _, bufnr in ipairs(del_bufs) do
                        vim.api.nvim_buf_delete(bufnr, {})
                    end
                end
            end)
        end,
    })
end)
