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
    opts = {
      ui = {
        border = "rounded",
      },
    },
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
        callback = function(ev)
          local tmp = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition)
          vim.keymap.set("n", "K", vim.lsp.buf.hover)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition)
          vim.keymap.set("n", "gr", vim.lsp.buf.references)
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format { async = true }
          end, tmp)
        end,
      })

      require("lazydev").setup {
        runtime = nil,
        debug = false,
        integrations = {},
        library = {},
        enabled = function(root_dir)
          -- TODO: Now always return true when lua file, need to check neovim plugin file.
          return true
          -- if .lua file exists in root_dir, return true
          -- return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
        end,
      }
    end,
  },
}
