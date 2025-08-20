return {
  "Kohei-Wada/boil.nvim",
  opts = {
    templates = {
      {
        name = "Default Template",
        path = "~/templates",
        variables = {
          author = "Kohei Wada",
        },
      },
      {
        name = "GitHub .gitignore",
        path = "~/ghq/github.com/github/gitignore",
        filter = function(template)
          local path = template.path
          return path:match "%.gitignore$" or path:match "gitignore%.template"
        end,
      },
    },
    variables = {
      date = function()
        return os.date "%Y-%m-%d"
      end,
      author = "Default Author",
    },
  },
  lazy = false,
}
