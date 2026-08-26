return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "hrsh7th/cmp-nvim-lsp" },

  opts = {
    enable = {
      "bashls",
      "lua_ls",
      "pylsp",
      "ruff",
    },

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
    -- mason.nvim itself is only loaded on :Mason, so put its bin dir on PATH here
    vim.env.PATH = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "bin") .. ":" .. vim.env.PATH

    require("lazydev").setup {}

    for server, config in pairs(opts.servers) do
      vim.lsp.config(server, config)
    end
    vim.lsp.enable(opts.enable)

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(event)
        local opt = { buffer = event.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opt)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opt)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opt)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opt)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opt)
        vim.keymap.set("n", "<space>f", function()
          vim.lsp.buf.format { async = true }
        end, opt)
      end,
    })
  end,
}
