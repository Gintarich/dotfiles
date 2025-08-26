return {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets', "L3MON4D3/LuaSnip" },
    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = 'super-tab' },
        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            accept = { auto_brackets = { enabled = true } },
            documentation = {
                auto_show = true,
                window = {
                    border = 'rounded',
                    -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
                },
                auto_show_delay_ms = 500,
            },
            ghost_text = { enabled = true },
            menu = {
                border = 'rounded',
                draw = {
                    columns = { { "source_name", gap = 1 }, { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
                    components = {
                        source_name = {
                            width = { max = 30 },
                            text = function(ctx) return "[" .. string.upper(ctx.source_name) .. "]" end,
                            highlight = 'BlinkCmpSource',
                        }
                    }
                }
            }
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'snippets', 'lsp', 'path', 'buffer' },
            per_filetype = {
                markdown = { "buffer" },
            },
        },
        snippets = {
            preset = "luasnip",
        },
        signature = {
            window = { border = 'rounded' },
            enabled = true,
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
}


