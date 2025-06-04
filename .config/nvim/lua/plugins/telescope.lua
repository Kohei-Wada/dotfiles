return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
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
      find_files = {
        theme = "ivy",
      },
      live_grep = {
        theme = "ivy",
      },
      help_tags = {
        theme = "ivy",
      },
      man_pages = {
        theme = "ivy",
      },
      git_files = {
        theme = "ivy",
      },
      buffers = {
        theme = "ivy",
        mappings = {
          i = {
            ["<C-d>"] = function(prompt_bufnr)
              require("telescope.actions").delete_buffer(prompt_bufnr)
            end,
          },
        },
      },

      command_history = {
        theme = "ivy",
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

      zoxide = {},

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
        if cmdtype == ":" then
          builtin.command_history()
        end
      end,
      desc = "Telescope - Command history",
      mode = { "c" },
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Telescope - Find files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Telescope - Grep",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Telescope - Buffers",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Telescope - Help tags",
    },
    {
      "<leader>fm",
      function()
        require("telescope.builtin").man_pages()
      end,
      desc = "Telescope - Man pages",
    },
    {
      "<leader>FF",
      function()
        require("telescope.builtin").git_files()
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
