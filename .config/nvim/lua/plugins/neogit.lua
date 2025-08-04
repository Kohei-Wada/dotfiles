return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
  },

  opts = {
    kind = "tab",
    disable_signs = true,
    disable_context_highlighting = true,
    disable_commit_confirmation = true,
    disable_builtin_notifications = false,
    auto_refresh = true,
    disable_insert_on_commit = true,
    commit_editor = {
      show_staged_diff = true,
      kind = "tab",
    },
  },

  config = function(_, opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "Neogit*",
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
      end,
    })

    require("neogit").setup(opts)
  end,

  keys = {
    {
      "<leader>ng",
      function()
        require("neogit").open()
      end,
      desc = "Neogit - Status",
    },
  },
}
