return{
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    root_markers = { "package.json", ".git" },
    init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
            css = true,
            javascript = true,
        },
        provideFormatter = true,
    },
    settings ={
      html = {
        customData = {
          vim.fn.expand("~/.local/share/lsp-data/svg.html-data.json")
        }
      }
    }
}
