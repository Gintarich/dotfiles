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
            require('rose-pine').setup({
                disable_italics = false,
                highlight_groups = {
                    ["@markup.strong"]                 = { fg = "love", bold = true },
                    ["@markup.italic"]                 = { fg = "foam", italic = true },
                    ["@markup.strong.markdown"]        = { fg = "love", bold = true },
                    ["@markup.italic.markdown"]        = { fg = "foam", italic = true },
                    ["@markup.strong.markdown_inline"] = { fg = "love", bold = true },
                    ["@markup.italic.markdown_inline"] = { fg = "foam", italic = true },
                    -- popup
                    BlinkCmpMenu                       = { fg = "text", bg = "surface" },
                    BlinkCmpMenuBorder                 = { fg = "muted", bg = "surface" },
                    -- BlinkCmpMenuSelection              = { fg = "base", bg = "highlight_high", bold = true },
                    -- item text
                    BlinkCmpLabel                      = { fg = "text" },
                    BlinkCmpLabelMatch                 = { fg = "love", bold = true },
                    BlinkCmpLabelDetail                = { fg = "muted" },
                    BlinkCmpLabelDescription           = { fg = "muted" },
                    -- kinds (global + per-kind)
                    BlinkCmpKind                       = { fg = "iris" },
                    BlinkCmpKindFunction               = { fg = "foam" },
                    BlinkCmpKindMethod                 = { fg = "foam" },
                    BlinkCmpKindVariable               = { fg = "rose" },
                    BlinkCmpKindField                  = { fg = "rose" },
                    BlinkCmpKindClass                  = { fg = "pine" },
                    BlinkCmpKindInterface              = { fg = "pine" },
                    BlinkCmpKindModule                 = { fg = "gold" },
                    -- source tag
                    BlinkCmpSource                     = { fg = "subtle" },
                    -- docs/signature windows
                    BlinkCmpDoc                        = { fg = "text", bg = "surface" },
                    BlinkCmpDocBorder                  = { fg = "muted", bg = "surface" },
                    BlinkCmpSignatureHelp              = { fg = "text", bg = "surface" },
                }
            })

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
