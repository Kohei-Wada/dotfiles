return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {
      debug = false,
      enabled = true,
    },
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    dependencies = { "williamboman/mason-lspconfig" },
    opts = {},

    -- lazy loads dependencies before their parent, so mason-lspconfig carries no
    -- opts of its own: setting it up there would run before mason.setup().
    config = function(_, opts)
      require("mason").setup(opts)
      require("mason-lspconfig").setup {
        automatic_enable = false,
        ensure_installed = {
          "bashls",
          "lua_ls",
          "pylsp",
          "ruff",
        },
      }
    end,
  },

  {
    "williamboman/mason-lspconfig",
    lazy = true,
  },
}
