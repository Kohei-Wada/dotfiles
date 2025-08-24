return {
  "Kohei-Wada/boil.nvim",
  cmd = "Boil",
  opts = {
    templates = {
      {
        name = "Boil Bash Template",
        path = "~/ghq/github.com/Kohei-Wada/boil.nvim/examples/templates/bash",
        variables = {
          author = "Kohei Wada",
        },
      },
    },
    variables = {
      date = function()
        return os.date "%Y-%m-%d"
      end,
      author = "Default Author",
    },
    logger = {
      level = vim.log.levels.ERROR,
    },
  },
}
