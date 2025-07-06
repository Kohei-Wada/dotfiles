return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
    {
      "jvgrootveld/telescope-zoxide",
      dependencies = {
        "nvim-lua/popup.nvim",
      },
    },
  },

  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-R>"] = require("telescope.actions").to_fuzzy_refine,
        },
      },
    },
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
      git_branches = {
        theme = "ivy",
      },
      registers = {
        theme = "ivy",
      },
      buffers = {
        theme = "ivy",
        mappings = {
          i = {
            ["<C-d>"] = require("telescope.actions").delete_buffer,
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
            ["<C-f>"] = require("telescope.actions").edit_command_line,
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
    local telescope = require "telescope"
    telescope.setup(opts)
    telescope.load_extension "fzf"
    telescope.load_extension "zoxide"
  end,

  keys = {
    {
      "<C-r>",
      function()
        local cmdtype = vim.fn.getcmdtype()
        local builtin = require "telescope.builtin"
        if cmdtype == ":" then
          builtin.command_history()
        end
      end,
      desc = "Telescope - Command history",
      mode = { "c" },
    },
    {
      "<leader>ff", -- find files
      require("telescope.builtin").find_files,
      desc = "Telescope - Find files",
    },
    {
      "<leader>fg",
      require("telescope.builtin").live_grep,
      desc = "Telescope - Grep",
    },
    {
      "<leader>fB", -- find branches
      require("telescope.builtin").git_branches,
      desc = "Telescope - Branches",
    },
    {
      "<leader>fb", -- find buffers
      require("telescope.builtin").buffers,
      desc = "Telescope - Buffers",
    },
    {
      "<leader>fr", -- find registers
      require("telescope.builtin").registers,
      desc = "Telescope - Registers",
    },
    {
      "<leader>fh", -- find help tags
      require("telescope.builtin").help_tags,
      desc = "Telescope - Help tags",
    },
    {
      "<leader>fm", -- find man pages
      require("telescope.builtin").man_pages,
      desc = "Telescope - Man pages",
    },
    {
      "<leader>FF",
      require("telescope.builtin").git_files,
      desc = "Telescope - Git Files",
    },
    {
      "<leader>zi",
      function()
        require("telescope").extensions.zoxide.list(require("telescope.themes").get_ivy {})
      end,
      desc = "Telescope - Zoxide",
    },
  },
}
