
-- ---@module 'obsidian'   
-- local obs = require("obsidian")

-- to rewrap existing files use gggqG
vim.bo.textwidth = 140
vim.opt_local.formatoptions:append("t")
-- vim.wo.wrap = true;
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.colorcolumn = "140"
vim.keymap.set('n', '<leader>nl',"<cmd>Obsidian links<cr>",{buffer = true})

-- require('render-markdown').setup({
--     completions = { lsp = { enabled = true } },
-- })
--
