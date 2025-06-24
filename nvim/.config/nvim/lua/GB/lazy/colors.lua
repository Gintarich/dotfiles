return {
    {
        'morhetz/gruvbox',
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        -- config = function ()
            --     vim.cmd.colorscheme("tokyonight-night")
            -- end
        },
        {
            "rose-pine/neovim",
            name = "rose-pine",
            config = function()
                require('rose-pine').setup({ })
                vim.cmd("colorscheme rose-pine-moon")
                vim.o.background = "dark"
                vim.cmd("highlight Normal guibg=none")
            end
        }

}
--    "bartekprtc/gruv-vsassist.nvim",
--    config = function()
    --        require("gruv-vsassist").setup({
        --            -- Enable transparent background
        --            transparent = false,
        --
        --            -- Enable italic comment
        --            italic_comments = true,
        --
        --            -- Disable nvim-tree background color
        --            disable_nvimtree_bg = true,
        --
        --            -- Override colors (see ./lua/gruv-vsassist/colors.lua)
        --            color_overrides = {
            --                vscLineNumber = '#FFFFFF',
            --            },
            --        })
            --    end

