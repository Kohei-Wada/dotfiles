local opt = vim.opt

-- Basic settings
opt.shortmess:append "I" -- Do not show messages at startup
opt.fileencoding = "utf-8" -- Set file encoding to UTF-8
opt.backup = false -- Do not create backup files
opt.writebackup = false -- Do not create autosave files
opt.swapfile = false -- Do not create swap files
opt.modifiable = true -- Make buffer modifiable
opt.conceallevel = 1 -- Conceal level for syntax highlighting

-- Display settings
opt.number = true -- Show current line number
opt.relativenumber = true -- Show relative line numbers
opt.cmdheight = 2 -- Set command line height to 2 lines
opt.laststatus = 2 -- Always show status line
opt.signcolumn = "yes:1" -- Always show sign column to prevent width changes
opt.cursorlineopt = "number" -- Highlight current line number
opt.cursorline = true -- Highlight current line
opt.modeline = true -- Show modeline at the bottom of the file
opt.modelines = 5 -- Set number of modelines to check

-- Indentation settings
opt.tabstop = 4 -- Set tab width to 4 spaces
opt.shiftwidth = 4 -- Set shift width to 4 spaces
opt.expandtab = true -- Convert tabs to spaces

-- Other settings
opt.backspace = "indent,eol,start,nostop" -- Allow backspace to delete indent, eol, and start
opt.whichwrap = "b,s,h,l,<,>,[,],~" -- Allow cursor to move across lines with wrap
opt.completeopt = "menu,menuone,noselect" -- Set completion options
opt.hlsearch = true -- Highlight search results
-- opt.clipboard:append("unnamedplus")       -- Use system clipboard

vim.diagnostic.config { virtual_text = true }
