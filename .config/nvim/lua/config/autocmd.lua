vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  desc = "Don't continue comment on new line when pressing Enter",
  callback = function()
    vim.opt_local.formatoptions:remove "c"
    vim.opt_local.formatoptions:remove "r"
    vim.opt_local.formatoptions:remove "o"
  end,
})

-- Highlight when yanking (copying) text
-- Try it with `yap` in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Extention of % command
-- Try it with `%` on a `function`, `if`, `for`, etc.
-- See `:help matchit`
vim.api.nvim_create_autocmd("VimEnter", {
  command = "MatchEnable",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "gitrebase", "gitconfig", "gitlog" },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
  end,
})
