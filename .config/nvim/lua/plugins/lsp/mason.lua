return {
  {
    "folke/lazydev.nvim",
    lazy = true,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {},
  },

  {
    "williamboman/mason-lspconfig",
    event = { "InsertEnter", "VeryLazy" },
    opts = {
      automatic_enable = true,
      ensure_installed = {
        "bashls",
        "lua_ls",
        "pylsp",
        "ruff",
      },
    },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },

    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

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

      require("lazydev").setup {
        runtime = nil,
        debug = false,
        integrations = {},
        library = {},
        enabled = true,
      }
    end,
  },
}
