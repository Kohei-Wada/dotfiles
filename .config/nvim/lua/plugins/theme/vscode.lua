return {
  "Mofiqul/vscode.nvim",
  opts = {
    -- Alternatively set style in setup
    -- style = 'light'

    -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Underline `@markup.link.*` variants
    underline_links = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Apply theme colors to terminal
    terminal_colors = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
      -- vscLineNumber = "#FFFFFF",
    },
  },

  config = function(_, opts)
    if vim.g.neovide then
      opts.transparent = false
    end
    require("vscode").setup(opts)
    -- vim.cmd("colorscheme vscode")
  end,
}
