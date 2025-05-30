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
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    tabline = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
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
