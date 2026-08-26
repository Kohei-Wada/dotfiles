-- Ctrl+[ 2 times to exit terminal mode
vim.api.nvim_set_keymap("t", "<C-[><C-[>", "<C-\\><C-n>", { noremap = true })

-- start terminal in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert",
})

-- disable number and relativenumber in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    set_terminal_keymaps()
  end,
})
