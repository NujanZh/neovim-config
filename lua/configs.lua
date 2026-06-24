-- General
vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.inccommand = "nosplit"

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wildmenu = true
vim.opt.showcmd = true
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.guicursor = "i:block"

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.autoread = true

-- Keymaps
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<leader>bb", "<cmd>make<CR>", { desc = "Build project" })
vim.keymap.set("n", "<leader>bq", "<cmd>copen<CR>", { desc = "Open build errors" })
vim.keymap.set("n", "<leader>bc", "<cmd>cclose<CR>", { desc = "Close build errors" })
