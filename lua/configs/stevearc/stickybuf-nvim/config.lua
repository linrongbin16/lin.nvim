require("stickybuf").setup()

vim.api.nvim_create_augroup("stickybuf_augroup", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    group = "stickybuf_augroup",
    callback = function()
        vim.defer_fn(function()
            local bufnrs = vim.api.nvim_list_bufs()
            local totals = 0
            local targets = 0
            local target_bufnr = nil
            if type(bufnrs) == "table" then
                for _, bn in ipairs(bufnrs) do
                    local bufname = vim.api.nvim_buf_get_name(bn)
                    if not require("stickybuf").should_auto_pin(bn) then
                        totals = totals + 1
                    end
                    if string.len(bufname) == 0 then
                        targets = targets + 1
                        target_bufnr = bn
                    end
                end
            end
            if
                totals > 0
                and targets > 0
                and totals > targets
                and target_bufnr ~= nil
            then
                vim.api.nvim_buf_delete(target_bufnr, {})
            end
        end, 1000)
    end,
})
