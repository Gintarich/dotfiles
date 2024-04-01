vim.o.foldcolumn = '1'         -- '0' is not bad
vim.o.foldlevel = 99           -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
--vim.opt.undodir = os.getenv("Home") .. "/.vim/undodir"
--vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
--vim.opt.signcolumn = "yes"
--vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
--vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.opt.virtualedit = "block"
vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
