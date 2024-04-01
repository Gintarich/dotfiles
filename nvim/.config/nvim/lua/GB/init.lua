require("GB.remap")
require("GB.set")
require("GB.lazy_init")

local augroup = vim.api.nvim_create_augroup
local GBGroup = augroup('GB', {})

local autocmd = vim.api.nvim_create_autocmd

local codeActionParams = {
    context = { only = { "quickfix" } },
    apply = true,
    filter = function(a)
        print("This is action i get")
        print(vim.inspect(a))
        return true
    end
}
local hoverLogic = function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
        -- choose one of coc.nvim and nvim lsp
        vim.lsp.buf.hover()
    end
end

autocmd('LspAttach', {
    group = GBGroup,
    callback = function(e)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = e.buf, desc = 'LSP: ' .. desc })
        end
        -- if e.name == "omnisharp" then e.server_capabilities.semanticTokensProvider = nil end
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        --require("lsp-overloads").setup(client,{ui={offset_y = -7}})
        if client.name == "omnisharp" then
            map('gd', require('omnisharp_extended').lsp_definition, '[G]oto [D]efinition')
        else
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        end
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('K', hoverLogic, 'Hover Documentation')
        map("<leader>vd", function() vim.lsp.buf.open_float() end, "Open float")
        map("<C-h>", function() vim.lsp.buf.signature_help() end, "")
        vim.keymap.set({ 'n', 'v' }, '<space>ca',
            function()
                vim.lsp.buf.code_action(codeActionParams) --,'refactor', 'source'}}}
            end,
            { desc = "[C]ode [A]ction" })
        --   map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        -- map("gd",function() vim.lsp.buf.definition() end, "[G]o to [D]efinition")
        -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    end
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
-- vim.api.nvim_create_autocmd("VimEnter", {
--	callback = function()
--		vim.cmd("set noshellslash")
--	end,
-- })
