return {
    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async',
        },
        config = function()
            -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            local language_servers = require("lspconfig").util.available_servers()
            for _, ls in ipairs(language_servers) do
                require("lspconfig")[ls].setup({
                    capabilities = capabilities,
                })
            end
            require("ufo").setup()
            -- require('ufo').setup({
            --     provider_selector = function(bufnr, filetype, buftype)
            --         return { 'treesitter', 'indent' }
            --     end
            -- })
        end
    },
    {
        "luukvbaal/statuscol.nvim",
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
                relculright = true,
                segments = {
                    { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                    { text = { "%s" },                  click = "v:lua.ScSa" },
                    { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                },
            })
        end,
    },
}
