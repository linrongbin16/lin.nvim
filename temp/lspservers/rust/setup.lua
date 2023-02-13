  ["rust_analyzer"] = function()
    require("rust-tools").setup({
      on_attach = function(client, bufnr)
        attach_ext(client, bufnr)
      end,
    })
  end,
