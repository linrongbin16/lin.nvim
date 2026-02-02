require("lsp-progress").setup({
  format = function(client_messages)
    if #client_messages > 0 then
      return table.concat(client_messages, " ")
    end
    return ""
  end,
  max_size = math.max(1, math.floor((vim.o.columns + 1) / 2)),
})
