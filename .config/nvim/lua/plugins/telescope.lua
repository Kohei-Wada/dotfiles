local insert_template = function()
  -- ~/templates
  local template_dir = vim.fn.expand "~/templates"
  require("telescope.builtin").find_files {
    prompt_title = "Templates",
    cwd = template_dir,
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", function()
        local selection = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        local file_path = selection.path
        local content = {}
        for line in io.lines(file_path) do
          table.insert(content, line)
        end
        local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, content)
      end)
      return true
    end,
  }
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
      current_buffer_fuzzy_find = {
        theme = "ivy",
      },
      command_history = {
        theme = "ivy",
        mappings = {
          i = {
            -- WARNING: if this style, telescope is not lazy loaded.
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
      "<leader>/", -- find buffers
      require("telescope.builtin").current_buffer_fuzzy_find,
      desc = "Telescope - Current buffer fuzzy find",
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
    {
      "<leader>ft",
      insert_template,
      desc = "Telescope - Find Template",
    },
  },
}
