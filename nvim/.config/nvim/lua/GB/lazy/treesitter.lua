return {
  'nvim-treesitter/nvim-treesitter',
  branch = "master", -- keep the old API (has nvim-treesitter.configs)
  build = ":TSUpdate",
  cmd = { "TSUpdate", "TSInstall", "TSUninstall", "TSUpdateSync", "TSInstallSync" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "c", "cpp", "c_sharp", "lua", "vim", "vimdoc",
      "markdown", "markdown_inline", "bash", "regex",
      "latex", "html", "css", "javascript", "python"
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  },
  -- config = function()
  --     require 'nvim-treesitter.configs'.setup {
  --         -- A list of parser names, or "all" (the five listed parsers should always be installed)
  --         ensure_installed = { "c", "cpp", "c_sharp", "lua", "vim", "vimdoc", "markdown_inline", "markdown", "bash", "regex", "latex", "html", "css", "javascript"},
  --
  --         -- Install parsers synchronously (only applied to `ensure_installed`)
  --         sync_install = false,
  --
  --         -- Automatically install missing parsers when entering buffer
  --         -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  --         auto_install = true,
  --
  --         modules = {},
  --
  --         ignore_install = {},
  --
  --         highlight = {
  --             -- false will disable the whole extension
  --             enable = true,
  --
  --             -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
  --             -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
  --             -- Using this option may slow down your editor, and you may see some duplicate highlights.
  --             -- Instead of true it can also be a list of languages
  --             additional_vim_regex_highlighting = false,
  --         },
  --     }
  -- end
}
