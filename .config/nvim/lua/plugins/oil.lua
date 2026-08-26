return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  lazy = false,
  opts = {
    columns = {},
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },

    keymaps = {
      ["<C-t>"] = false,
    },
  },

  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory", mode = { "n" } },
  },
}
