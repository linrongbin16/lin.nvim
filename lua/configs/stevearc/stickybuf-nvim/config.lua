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

            local function _got_target()
                return totals > 0
                    and targets > 0
                    and totals > targets
                    and target_bufnr ~= nil
            end

            if type(bufnrs) == "table" then
                for _, bn in ipairs(bufnrs) do
                    local buf_hidden =
                        vim.api.nvim_get_option_value("bufhidden", { buf = bn })
                    buf_hidden = type(buf_hidden) == "string"
                        and string.len(buf_hidden) > 0
                    local buf_listed =
                        vim.api.nvim_get_option_value("buflisted", { buf = bn })
                    local buf_loaded = vim.api.nvim_buf_is_loaded(bn)
                    local bufname = vim.api.nvim_buf_get_name(bn)
                    if not require("stickybuf").should_auto_pin(bn) then
                        totals = totals + 1
                    end
                    if
                        string.len(bufname) == 0
                        and not buf_hidden
                        and buf_listed
                        and buf_loaded
                    then
                        targets = targets + 1
                        target_bufnr = bn
                    end
                    if _got_target() then
                        break
                    end
                end
            end
            if _got_target() then
                vim.api.nvim_buf_delete(target_bufnr, {})
            end
        end, 1000)
    end,
})
