return {
  "aznhe21/actions-preview.nvim",
  event = "LspAttach",
  opts = {
    diff = {
      ctxlen = 3,
    },

    -- priority list of external command to highlight diff
    -- disabled by defalt, must be set by yourself
    highlight_command = {
      -- require("actions-preview.highlight").delta(),
      -- require("actions-preview.highlight").diff_so_fancy(),
      -- require("actions-preview.highlight").diff_highlight(),
    },

    -- priority list of preferred backend
    backend = { "telescope" },

    -- options related to telescope.nvim
    telescope = vim.tbl_extend(
      "force",
      require("telescope.themes").get_ivy(),
      -- a table for customizing content
      {
        -- a function to make a table containing the values to be displayed.
        -- fun(action: Action): { title: string, client_name: string|nil }
        make_value = nil,

        -- a function to make a function to be used in `display` of a entry.
        -- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
        -- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
        make_make_display = nil,
      }
    ),
  },

  config = function(_, opts)
    require("actions-preview").setup(opts)
    -- Find Code Actions
    vim.keymap.set({ "v", "n" }, "<leader>fa", require("actions-preview").code_actions)
  end,
}
