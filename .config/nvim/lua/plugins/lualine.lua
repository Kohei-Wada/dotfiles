return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
      },
      lualine_b = {
        "branch",
        "diff",
        "diagnostics",
      },
      lualine_c = {
        { "filename", path = 1 },
      },
      lualine_x = {},
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    tabline = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { "tabs" },
    },

    extensions = {
      "mason",
      "man",
      "oil",
      "lazy",
      "trouble",
      "quickfix",
    },
  },
}
