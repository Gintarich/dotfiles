vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Netrw" })

-- Document stuff
vim.keymap.set("n", "<leader>dm", "<cmd>Noice all<CR>", { desc = "[D]ocument [M]essages" })


vim.keymap.set("n", "<leader>hr", "<cmd>noh<CR>", { desc = "[H]ighlight [R]emove (clear search hl)" })


-- Moving lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- greatest remap ever (Delete in void register to continiue pasting)
vim.keymap.set("x", "<leader>P", [["_dP]])

-- next greatest remap ever : asbjornHalan
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
-- Copy in system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
-- vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = '[F]ormat current file' })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>rs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[R]ename string" })
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
--vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

vim.keymap.set("v", "<C-b>", 'c**<C-r>"**<Esc>', { desc = "Bold selection" })
vim.keymap.set('n', "<C-b>", 'viwc**<C-r>"**<Esc>', { desc = "Bold under cursor" })

vim.keymap.set("n", "<leader>pp", function()
  vim.lsp.buf.signature_help()
end)

--Obsidian
vim.keymap.set('n', '<leader>ns', "<cmd>Obsidian search<cr>")

vim.keymap.set("v", "<leader>ee", function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local script = table.concat(lines, "\n")

  local output = vim.fn.system({ "bash", "-s" }, script)
  if vim.v.shell_error ~= 0 then
    vim.notify(output, vim.log.levels.ERROR, { title = "Bash selection failed" })
    return
  end

  if output ~= "" then
    vim.notify(output, vim.log.levels.INFO, { title = "Bash output" })
  else
    vim.notify("Selection executed successfully", vim.log.levels.INFO, { title = "Bash" })
  end
end, { desc = "[E]xecute selection in bash" })


vim.keymap.set("n", "<leader>cn", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

-- Show diagnostics with aditional info
vim.keymap.set("n", "<leader>xd", function()
  local opts = {
    scope = "line",
    header = "", -- no "Diagnostics:" header
    prefix = "", -- no bullets
    format = function(d)
      local src = d.source and ("[" .. d.source .. "] ") or ""
      local code = d.code and ("(" .. tostring(d.code) .. ") ") or ""
      return src .. code .. d.message
    end,
  }
  vim.diagnostic.open_float(nil, opts)
end, { desc = "Line diagnostics (with source)" })
