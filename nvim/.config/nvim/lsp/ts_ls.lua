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
   settings = {},
 }
