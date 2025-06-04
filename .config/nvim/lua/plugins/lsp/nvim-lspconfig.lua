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
    local lspconfig = require "lspconfig"
    for server, config in pairs(opts.servers) do
      lspconfig[server].setup(config)
    end
  end,
}
