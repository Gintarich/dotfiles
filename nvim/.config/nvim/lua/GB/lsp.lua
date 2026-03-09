vim.lsp.enable({
  "luals", "ts_ls", "cssls", "htmlls", "bashls", "basedpyright", "tailwindcssls", "eslint_ls"
})

local lsp_icons = {
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = "󰊕 ",
  Interface = " ",
  Keyword = " ",
  Method = "ƒ ",
  Module = "󰏗 ",
  Property = " ",
  Snippet = " ",
  Struct = " ",
  Text = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
}

local completion_kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(completion_kinds) do
  completion_kinds[i] = lsp_icons[kind] and lsp_icons[kind] .. kind or kind
end


-- diagnostics
local icons = require('GB.incons')
vim.diagnostic.config({
  signs = {
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

local format_on_save_group = vim.api.nvim_create_augroup('lsp-format-on-save', { clear = false })

local function enable_format_on_save(bufnr)
  vim.api.nvim_clear_autocmds({ group = format_on_save_group, buffer = bufnr })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = format_on_save_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({
        bufnr = bufnr,
        async = false,
        timeout_ms = 2000,
      })
    end,
    desc = 'LSP format on save',
  })
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- if client and client:supports_method('textDocument/completion') then
    --     vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    -- end
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'LSP: ' .. desc })
    end
    enable_format_on_save(ev.buf)

    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    -- Smart hover show diagnostics or hover documentation.
    map('K', function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local lnum = cursor[1] - 1
      local diags = vim.diagnostic.get(ev.buf, { lnum = lnum })

      if #diags > 0 then
        vim.diagnostic.open_float(nil, { focusable = false, scope = 'line' })
        return
      end

      vim.lsp.buf.hover()
    end, 'Hover / Diagnostics')
    -- map("<C-h>", function() vim.lsp.buf.signature_help() end, "")
  end,

})


vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "css,eruby,html,htmldjango,less,pug,sass,scss",
  callback = function()
    vim.lsp.start({
      cmd = { "emmet-language-server", "--stdio" },
      root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
      -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
      -- **Note:** only the options listed in the table are supported.
      init_options = {
        ---@type table<string, string>
        includeLanguages = {},
        --- @type string[]
        excludeLanguages = {},
        --- @type string[]
        extensionsPath = {},
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
        preferences = {},
        --- @type boolean Defaults to `true`
        showAbbreviationSuggestions = true,
        --- @type "always" | "never" Defaults to `"always"`
        showExpandedAbbreviation = "always",
        --- @type boolean Defaults to `false`
        showSuggestionsAsSnippets = true,
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
        syntaxProfiles = {},
        --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
        variables = {},
      },
    })
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
