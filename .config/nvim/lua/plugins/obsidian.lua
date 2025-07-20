return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = { "markdown" }, -- load plugin only for markdown files
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "vault",
        path = "~/ghq/github.com/Kohei-Wada/Obsidian/vault",
        overrides = {
          new_notes_location = "01_FleetingNotes",
          notes_subdir = "01_FleetingNotes",
          templates = {
            folder = "99_Templates",
          },

          note_id_func = function(title)
            if title ~= nil then
              -- If title is not nil, use the title as the note ID.
              return title
            else
              -- If title is nil, just add 4 random uppercase letters to the suffix.
              local suffix = ""
              for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
              end
              return tostring(os.time()) .. "-" .. suffix
            end
          end,
        },
      },
    },
  },

  config = function(_, opts)
    require("obsidian").setup(opts)
    vim.keymap.set("n", "gf", "<Cmd>ObsidianFollowLink<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>nn", "<Cmd>ObsidianNewFromTemplate<CR>", { noremap = true, silent = true })
  end,
}
