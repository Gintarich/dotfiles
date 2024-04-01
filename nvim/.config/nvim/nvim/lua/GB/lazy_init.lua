local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("GB.lazy")

local opts = { noremap = true, silent = true }
--
-- ----------------------------------------------------------
local function quickfix()
    vim.lsp.buf.code_action({
        filter = function(a) return a.isPreferred end,
        apply = true
    })
end

vim.keymap.set('n', '<leader>qf', quickfix, { desc = "[q]uick fix" })


local make_code_action_params = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {
        diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    }
    return params
end

TEST = function()
    local params = make_code_action_params()
    -- params.context.only = { "quickfix" }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    local p = result[1].result[1]
    print(vim.inspect(p))

    vim.lsp.util.apply_workspace_edit(p, 'utf-8')
    --local mycodeaction = result[1]

    vim.lsp.buf.execute_command(p)
    --print(vim.inspect(result))
    -- for _, res in pairs(result or {}) do
    --     print(vim.inspect(mycodeaction))
    --     vim.lsp.util.apply_workspace_edit(mycodeaction.data, 'utf-8')
    --     for _, r in pairs(res.result or {}) do
    --         print(vim.inspect(r))
    --     end
    -- end
end

execute_code_action = function(kind)
    if not kind then return end
    local params = make_code_action_params()
    params.context.only = { kind }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            print(vim.inspect(r.command))
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

list_code_action_kinds = function()
    local params = make_code_action_params()
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for _, res in pairs(result or {}) do
        print(vim.inspect(res))
        print('---', 'CODE ACTIONS')
        for _, r in pairs(res.result or {}) do
            -- vim.pretty_print(r)
            print(r.kind)
        end
        print('---')
    end
end

