return {
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = vim.fs.root(0, { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }),
  single_file_support = true,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
  on_attach = function(client, _)
    -- Prefer eslint for formatting/fixes in JS/TS buffers.
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {},
}
