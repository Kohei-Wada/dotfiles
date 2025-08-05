vim.opt.cmdwinheight = 10 -- Set the height of the command-line window

vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  desc = "Disable line numbers and sign column in command-line window",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = ":",
  desc = "Disable cursorline in command-line window",
  callback = function()
    -- Delete quit commands from command history
    local patterns = {
      "^qa\\?!\\?$", -- q, qa, q!, qa!
      "^wq\\?a\\?!\\?$", -- w, wq, wa, wqa, w!, wq!, wa!, wqa!
    }

    for _, pattern in ipairs(patterns) do
      vim.cmd("g/" .. pattern .. "/d")
    end
  end,
})
