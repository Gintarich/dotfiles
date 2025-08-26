return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            latex = {
                enabled = false,
            },
        },
        config = function()
            require('render-markdown').setup({
                completions = { blink = { enabled = true } },
                code = {
                    border = 'thick',
                },
            })
        end,
    },

    {
        "folke/snacks.nvim",
        enabled = false,
        ---@type snacks.Config
        opts = {
            image = {
                -- To find image path
                resolve = function(_, src)
                    -- 1) Expand '~/…' ➜ '/home/you/…'
                    src = src:gsub("^~", vim.env.HOME)
                    -- 2) If it's a bare filename, look in the vault's attachments dir
                    local vault = vim.fn.expand("~/personal/Notes/ObsidianNotes")
                    local attaches = vault .. "/Media/Images/" -- <- adjust once
                    if not src:find("/") then                  -- no slashes → bare
                        local try = attaches .. src            -- e.g. .../TEST.png
                        if vim.uv.fs_stat(try) then            -- file exists?
                            return try                         -- ✔ use this path
                        end
                    end
                    -- 3) Anything else → let Snacks keep searching
                    return nil
                end,
                doc = {
                    max_width  = 80, -- cells (↓ from 80)
                    max_height = 40, -- cells (↓ from 40)
                },
                convert = {
                    magick = {
                        math = { "-density", "384", "{src}[0]", "-trim" },
                    },
                },
                -- debug = {
                --     request = true,
                --     placement = true,
                -- },
                math = {
                    enabled = true,     -- enable math expression rendering
                    -- in the templates below, `${header}` comes from any section in your document,
                    -- between a start/end header comment. Comment syntax is language-specific.
                    -- * start comment: `// snacks: header start`
                    -- * end comment:   `// snacks: header end`
                    latex = {
                        font_size = "large",
                        packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
                        tpl = [[
                            \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
                            \usepackage{${packages}}
                            \begin{document}
                            ${header}
                            { \${font_size} \selectfont
                            \color[HTML]{${color}}
                            ${content}}
                            \end{document}]],
                    },
                },
            }
        },
    },

    {
        "obsidian-nvim/obsidian.nvim",
        enabled = true,
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = false,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        ---@module 'obsidian'
        ---@type obsidian.config
        opts = {
            legacy_commands = false,
            ui = { enable = false },
            completion = {
                nvim_cmp = false,
                blink = true,
            },
            attachments = {
                img_folder = "Media/Images"
            },
            workspaces = {
                {
                    name = "Work",
                    path = "~/personal/Notes/ObsidianNotes",
                },
                {
                    name = "Coding",
                    path = "~/personal/Notes/PROGRAMMESANA",
                },
            },
        },
    }
}
