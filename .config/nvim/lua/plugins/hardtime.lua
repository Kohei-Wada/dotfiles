return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    disabled_filetypes = {
      "help",
      "qf",
      "netrw",
      "NvimTree",
      "lazy",
      "mason",
      "oil",

      -- neogit
      "Neogit*",

      -- vim-dadbod-ui
      "db*",

      -- neotest
      "neotest-summary",

      -- copilot chat
      "copilot-chat",

      -- trouble
      "trouble",
    },

    hints = {
      ["ko"] = {
        message = function()
          return "Use ko instead of O"
        end,
        length = 2,
      },
    },
  },

  keys = {
    { "<leader>hh", ":Hardtime toggle<CR>", desc = "Hardtime - Toggle" },
  },
}
