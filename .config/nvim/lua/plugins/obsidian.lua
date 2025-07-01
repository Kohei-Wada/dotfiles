return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = { "markdown" }, -- load plugin only for markdown files
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "github",
        path = "~/ghq/github.com/Kohei-Wada/Obsidian",
      },
    },

    -- see below for full list of options 👇
  },
}
