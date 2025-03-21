return {
  "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  event = "BufReadPre",
  opts = {
    indent = {
      char = "▏",
    },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },

  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
