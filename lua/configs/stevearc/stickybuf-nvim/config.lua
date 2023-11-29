require("stickybuf").setup()

vim.api.nvim_create_augroup("stickybuf_augroup", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    group = "stickybuf_augroup",
    callback = function()
        vim.schedule(function()
            local bufnrs = vim.api.nvim_list_bufs()
            local bufs_count = 0
            local del_bufnr = nil
            local del_count = 0
            if type(bufnrs) == "table" then
                for _, bufnr in ipairs(bufnrs) do
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    if not require("stickybuf").should_auto_pin(bufnr) then
                        bufs_count = bufs_count + 1
                    end
                    if string.len(bufname) == 0 then
                        del_count = del_count + 1
                        del_bufnr = bufnr
                    end
                end
            end
            if bufs_count > del_count + 1 and del_bufnr ~= nil then
                vim.api.nvim_buf_delete(del_bufnr, {})
            end
        end)
    end,
})
