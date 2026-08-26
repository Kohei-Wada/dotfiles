local function read_prompt_file(path)
  return table.concat(vim.fn.readfile(path), "\n")
end

local function make_prompts()
  local ps = {}
  local filtered_prompt_files =
    vim.fn.globpath(vim.fn.stdpath "config" .. "/lua/plugins/copilot/prompts", "*.txt", false, true)
  for _, file in ipairs(filtered_prompt_files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    if not ps[name] then
      ps[name] = {
        prompt = read_prompt_file(file),
        selection = require("CopilotChat.select").visual,
      }
    end
  end

  return ps
end

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
  },
  branch = "main",
  cmd = {
    "CopilotChatExplain",
    "CopilotChatReview",
    "CopilotChatFix",
    "CopilotChatFixJa",
    "CopilotChatOptimize",
    "CopilotChatDocs",
    "CopilotChatTests",
    "CopilotChatCommit",
    "CopilotChatCommitJa",
    "CopilotChatRefactor",
    "CopilotChatSearch",
    "CopilotChatSummarize",
  },

  config = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-*",
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
      end,
    })

    require("CopilotChat").setup {
      window = {
        layout = "vertical",
      },
      system_prompt = read_prompt_file(vim.fn.stdpath "config" .. "/lua/plugins/copilot/system/System.txt"),
      prompts = make_prompts(),
    }
  end,

  keys = {
    {
      "<C-t>",
      function()
        require("CopilotChat").toggle()
      end,
      desc = "CopilotChat - Toggle",
      mode = { "n", "v" },
    },
  },
}
