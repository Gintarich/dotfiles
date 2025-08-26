return {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
        -- add any options here
    },

    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    },
    config = function ()
        require("noice").setup({
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["mp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                }
            },

            -- views = {
            --     vsplit = {
            --         enter    = false,   -- keep focus in the current window
            --         position = "right", -- already the default for vsplit; explicit here
            --         size     = 40,      -- 40 columns wide  (or use "30%" for relative)
            --     },
            -- },
            -- routes = {
            --     {
            --         filter = { event = "msg_show" },
            --         view   = "vsplit",
            --     },
            -- },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = false, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true, -- add a border to hover docs and signature help
            }
        })
    end,
}
