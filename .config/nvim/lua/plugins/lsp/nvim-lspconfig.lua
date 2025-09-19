return {
  "neovim/nvim-lspconfig",
  lazy = true,

  opts = {
    -- Add any additional LSP servers you want to configure here
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            format = {
              enable = false,
            },
          },
        },
      },
    },
  },

  config = function(_, opts)
    -- Setup LSP servers
    for server, config in pairs(opts.servers) do
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
}
