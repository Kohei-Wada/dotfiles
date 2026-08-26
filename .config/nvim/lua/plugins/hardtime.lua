return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
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

    ui = {
      enter = true,
      focusable = true,
      border = {
        style = "rounded",
        text = {
          top = "Hardtime Report",
          top_align = "center",
        },
      },
      position = "50%",
      size = {
        width = "80%",
        height = "60%",
      },
    },

    hints = {
      ["ko"] = {
        message = function()
          return "Use O instead of ko"
        end,
        length = 2,
      },

      ["ggvG%$"] = {
        message = function()
          return "Use ggVG instead of ggvG$"
        end,
        length = 5,
      },
    },
  },

  keys = {
    { "<leader>hh", ":Hardtime toggle<CR>", desc = "Hardtime - Toggle" },
  },
}
