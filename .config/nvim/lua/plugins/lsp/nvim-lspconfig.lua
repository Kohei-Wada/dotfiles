return {
  "neovim/nvim-lspconfig",
  lazy = true,

  opts = {
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

      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                maxLineLength = 100,
              },
              ruff = {
                enabled = true,
                -- 追加オプション例: lineLength = 100,
              },
            },
          },
        },
      },
    },
  },

  config = function(_, opts)
    for server, config in pairs(opts.servers) do
      vim.lsp.config(server, config)
    end
  end,
}
