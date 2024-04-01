return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
        "folke/neodev.nvim",
        "hrsh7th/cmp-nvim-lsp",
        { 'j-hui/fidget.nvim', opts = {} },
        "Hoffs/omnisharp-extended-lsp.nvim",
    },

    config = function()
        local icons = require('GB.incons')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities())

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {"lua_ls","omnisharp","clangd"},
            handlers = {
                function(server_name) -- default handler (optional)
                    if server_name == "lua_ls" then
                        require("neodev").setup {
                            capabilities = capabilities
                        }
                    end
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ["omnisharp"] = require("GB/lazy/lsps/omnisharp").omnisharp_setup(capabilities)
            }
        })
        vim.diagnostic.config({
            signs ={
                active = true,
                values ={
                    {name = "DiagnosticSignError", text = icons.diagnostics.Error},
                    {name = "DiagnosticSignWarn", text = icons.diagnostics.Warning},
                    {name = "DiagnosticSignHint", text = icons.diagnostics.Hint},
                    {name = "DiagnosticSignInfo", text = icons.diagnostics.Information},
                },
            },
            virtual_text = true,
            update_in_insert = false,
            underline = true,
            severity_sort = true,
            float = {
                focusable = true,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        })
        for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
        end
    end
}

--local has_words_before = function()
--    unpack = unpack or table.unpack
--    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--end
--
--local feedkey = function(key, mode)
--    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
--end
