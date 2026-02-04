return{
    "tpope/vim-fugitive",
    config = function ()
      vim.keymap.set("n", "<leader>ga", ":Git add .<CR>", {desc="[G]it [A]dd all"})
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git, {desc="[G]it [S]tatus"})
      vim.keymap.set("n", "<leader>gc", ":Git commit -m \"\"<Left>", {desc="[G]it [C]ommit"})
      vim.keymap.set("n", "<leader>gP", ":Git push<CR>", {desc="[G]it [P]ush"})
      vim.keymap.set("n", "<leader>gF", ":Git fetch<CR>", {desc="[G]it [F]etch"})
      vim.keymap.set("n", "<leader>gd", ":Git diff<CR>", {desc="[G]it [D]iff"})
      vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", {desc="[G]it [B]lame"})
      vim.keymap.set("n", "<leader>gl", ":Git log<CR>", {desc="[G]it [L]og"})
    end
}
