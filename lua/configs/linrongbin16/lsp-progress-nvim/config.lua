require("lsp-progress").setup({
  format = function(client_messages)
    if #client_messages > 0 then
      return table.concat(client_messages, " ")
    end
    return ""
  end,
})
