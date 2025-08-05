local function get_logo()
  math.randomseed(os.time())
  local ls = vim.fn.globpath(vim.fn.stdpath "config" .. "/lua/plugins/dashboard/logo", "*.txt", true, true)
  return vim.fn.readfile(ls[math.random(1, #ls)], "\n")
end

return {
  "nvimdev/dashboard-nvim",
  enabled = false, -- disable this plugin by default
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VimEnter",
  opts = {
    theme = "hyper",
    shortcut_type = "number",
    config = {
      header = get_logo(),
      shortcut = {
        -- action can be a function type
      },
      packages = { enable = true },
      project = { enable = false },
      mru = { enable = false },
      footer = {}, -- footer
    },
  },
}
