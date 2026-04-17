vim.g.rustaceanvim = function()
  return {
    -- LSP configuration
    server = {
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          completion = {
            autoimport = {
              enable = false,
            },
          },
        },
      },
    },
  }
end
