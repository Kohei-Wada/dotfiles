local function builtin(name)
  return function()
    require("telescope.builtin")[name]()
  end
end

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

  -- opts must be a function: a plain table would run `require` at spec-eval time
  opts = function()
    local actions = require "telescope.actions"
    return {
      defaults = {
        mappings = {
          i = {
            ["<C-R>"] = actions.to_fuzzy_refine,
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
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
        current_buffer_fuzzy_find = {
          theme = "ivy",
        },
        command_history = {
          theme = "ivy",
          mappings = {
            i = {
              ["<C-f>"] = actions.edit_command_line,
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
    }
  end,

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
        if vim.fn.getcmdtype() == ":" then
          require("telescope.builtin").command_history()
        end
      end,
      desc = "Telescope - Command history",
      mode = { "c" },
    },
    { "<leader>ff", builtin "find_files", desc = "Telescope - Find files" },
    { "<leader>fg", builtin "live_grep", desc = "Telescope - Grep" },
    { "<leader>fB", builtin "git_branches", desc = "Telescope - Branches" },
    { "<leader>fb", builtin "buffers", desc = "Telescope - Buffers" },
    { "<leader>/", builtin "current_buffer_fuzzy_find", desc = "Telescope - Current buffer fuzzy find" },
    { "<leader>fr", builtin "registers", desc = "Telescope - Registers" },
    { "<leader>fh", builtin "help_tags", desc = "Telescope - Help tags" },
    { "<leader>fm", builtin "man_pages", desc = "Telescope - Man pages" },
    { "<leader>FF", builtin "git_files", desc = "Telescope - Git Files" },
    {
      "<leader>zi",
      function()
        require("telescope").extensions.zoxide.list(require("telescope.themes").get_ivy {})
      end,
      desc = "Telescope - Zoxide",
    },
  },
}
