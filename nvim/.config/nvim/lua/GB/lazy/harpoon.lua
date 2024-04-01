return{
    'ThePrimeagen/harpoon',
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n","<leader>a",mark.add_file,{desc = "[A]dd file to harpoon list"})
        vim.keymap.set("n","<C-e>",ui.toggle_quick_menu)

        vim.keymap.set("n",'ā', function() ui.nav_file(1) end)
        vim.keymap.set("n","š", function() ui.nav_file(2) end)
        vim.keymap.set("n","ž", function() ui.nav_file(3) end)
        vim.keymap.set("n","č", function() ui.nav_file(4) end)
    end,
}
