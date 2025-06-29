local M = {
    "hrsh7th/nvim-cmp",
    enabled = false,
    event = "InsertEnter",
    dependencies = {
        {
            "hrsh7th/cmp-nvim-lsp",
            event = "InsertEnter",
        },
        {
            "hrsh7th/cmp-emoji",
            event = "InsertEnter",
        },
        {
            "hrsh7th/cmp-buffer",
            event = "InsertEnter",
        },
        {
            "hrsh7th/cmp-path",
            event = "InsertEnter",
        },
        {
            "hrsh7th/cmp-cmdline",
            event = "InsertEnter",
        },
        {
            "saadparwaiz1/cmp_luasnip",
            event = "InsertEnter",
        },
        {
            "L3MON4D3/LuaSnip",
            event = "InsertEnter",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
        },
        {
            "hrsh7th/cmp-nvim-lua",
        },
        {
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
    },
}

function M.config()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    -- cmp_setup object
    local cmp_setup = {}


    cmp_setup.sources = cmp.config.sources({
        { name = 'path' },
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        --{ name = 'buffer' },
    })

    cmp_setup.snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    }

    cmp_setup.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    }

    cmp_setup.mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function()
            if luasnip.expandable() and cmp.visible() then
                luasnip.expand()
            elseif cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    cmp.confirm()
                end
            elseif luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                require("neotab").tabout()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    })

    -- Configure autopairs
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )
    require("luasnip.loaders.from_vscode").lazy_load()
    cmp.setup({
        snippet = cmp_setup.snippet,
        window = cmp_setup.window,
        mapping = cmp_setup.mapping,
        sources = cmp_setup.sources,
    })
end

return M
