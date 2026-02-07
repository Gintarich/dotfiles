return {
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
    },
    root_markers = {
        '.eslintrc',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.yaml',
        '.eslintrc.yml',
        '.eslintrc.json',
        'eslint.config.js',
        'eslint.config.mjs',
        'package.json',
    },
    on_attach = function(client, _)
        -- Ensure eslint can be selected by vim.lsp.buf.format().
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
    end,
    settings = {
        validate = 'on',
        packageManager = nil,
        useESLintClass = false,
        experimental = {
            useFlatConfig = true,
        },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = 'separateLine',
            },
            showDocumentation = {
                enable = true,
            },
        },
        format = true,
        rulesCustomizations = {},
        run = 'onType',
        problems = {
            shortenToSingleLine = false,
        },
        nodePath = '',
        workingDirectory = { mode = 'location' },
    },
}
