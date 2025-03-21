return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build =
      "cmake -S. -Bbuild -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
    {
      "jvgrootveld/telescope-zoxide",
      dependencies = {
        "nvim-lua/popup.nvim",
      },
    },
  },

  opts = {
    pickers = {
      command_history = {
        mappings = {
          i = {
            -- WARNING: if this style , telescpoe is not lazy loaded.
            -- ["<C-f>"] = require("telescope.actions").edit_command_line,

            -- This style is lazy loaded.
            ["<C-f>"] = function(prompt_bufnr)
              return require("telescope.actions").edit_command_line(prompt_bufnr)
            end,
          },
        },
      },
    },

    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },

      zoxide = {
        mappings = {
          ["<C-f>"] = {
            keepinsert = true,
            action = function(selection)
              local builtin = require("telescope.builtin")
              builtin.find_files(require("telescope.themes").get_ivy({ cwd = selection.path }))
            end,
          },
        },
      },
    },
  },

  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("zoxide")
  end,

  keys = {
    {
      "<C-r>",
      function()
        local cmdtype = vim.fn.getcmdtype()
        local builtin = require("telescope.builtin")
        local themes = require("telescope.themes").get_ivy({})
        if cmdtype == ":" then
          builtin.command_history(themes)
        end
      end,
      desc = "Telescope - Command history",
      mode = { "c" },
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files(require("telescope.themes").get_ivy({}))
      end,
      desc = "Telescope - Find files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep(require("telescope.themes").get_ivy({}))
      end,
      desc = "Telescope - Grep",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers(require("telescope.themes").get_ivy({}))
      end,
      desc = "Telescope - Buffers",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags(require("telescope.themes").get_ivy({}))
      end,
      desc = "Telescope - Help tags",
    },
    {
      "<leader>fm",
      function()
        require("telescope.builtin").man_pages(require("telescope.themes").get_ivy({}))
      end,
      desc = "Telescope - Man pages",
    },
    {
      "<leader>FF",
      function()
        require("telescope.builtin").git_files(require("telescope.themes").get_ivy({}))
      end,
      desc = "Telescope - Git Files",
    },
    {
      "<leader>zi",
      function()
        require("telescope").extensions.zoxide.list(require("telescope.themes").get_ivy({}))
      end,
      desc = "Telescope - Zoxide",
    },
  },
}
