print("Setting up LSP")

vim.lsp.enable({
    "luals",
})

local icons = require('GB.incons')
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

-- for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
--     vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
-- end



--
--     --local has_words_before = function()
--         --    unpack = unpack or table.unpack
--         --    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--         --    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--         --end
--         --
--         --local feedkey = function(key, mode)
--             --    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
--             --end
