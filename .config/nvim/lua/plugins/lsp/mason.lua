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
  },

  {
    "williamboman/mason-lspconfig",
    lazy = true,
    opts = {
      automatic_enable = false,
      ensure_installed = {
        "bashls",
        "lua_ls",
        "pylsp",
        "ruff",
      },
    },
  },
}
