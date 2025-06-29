vim.lsp.enable({
    "luals",
})


-- diagnostics
local icons = require('GB.incons')
vim.diagnostic.config({
    signs ={
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
        }
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

-- standard autocplete

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- if client and client:supports_method('textDocument/completion') then
        --     vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        -- end
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'LSP: ' .. desc })
        end
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        -- map('K', hoverLogic, 'Hover Documentation')
        -- map("<C-h>", function() vim.lsp.buf.signature_help() end, "")
    end,

})
--
-- vim.cmd[[set completeopt+=menuone,noselect,popup]]


--     --local has_words_before = function()
--         --    unpack = unpack or table.unpack
--         --    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--         --    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--         --end
--         --
--         --local feedkey = function(key, mode)
--             --    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
--             --end
