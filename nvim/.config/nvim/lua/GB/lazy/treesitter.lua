return {
  'nvim-treesitter/nvim-treesitter',
  branch = "main",
  build = ":TSUpdate",
  cmd = { "TSUpdate", "TSInstall", "TSUninstall", "TSUpdateSync", "TSInstallSync" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "c", "cpp", "c_sharp", "lua", "vim", "vimdoc",
      "markdown", "markdown_inline", "bash", "regex",
      "latex", "html", "css", "javascript", "typescript", "tsx", "python",
      "json", "yaml", "toml"
    },
    -- "latex", "html", "css", "javascript", "javascriptreact", "typescriptreact", "python"
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  },
  config = function(_, opts)
    require('nvim-treesitter').setup(opts)

    local ts_config = require('nvim-treesitter.config')
    local get_install_dir = ts_config.get_install_dir
    ts_config.get_install_dir = function(dir_name)
      local dir = get_install_dir(dir_name)
      if dir_name == "" then
        return vim.fs.normalize(dir)
      end
      return dir
    end

    vim.treesitter.language.register("javascript", "js")
    vim.treesitter.language.register("javascript", "mjs")
    vim.treesitter.language.register("javascript", "cjs")
    vim.treesitter.language.register("typescript", "ts")
    vim.treesitter.language.register("typescript", "mts")
    vim.treesitter.language.register("typescript", "cts")
    vim.treesitter.language.register("tsx", "jsx")
    vim.treesitter.language.register("tsx", "javascriptreact")
    vim.treesitter.language.register("tsx", "typescriptreact")
    vim.treesitter.language.register("bash", "sh")
    vim.treesitter.language.register("bash", "zsh")

    local ts_augroup = vim.api.nvim_create_augroup("GB-treesitter-highlight", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = ts_augroup,
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
        pcall(vim.treesitter.start, buf)
      end
    end
  end,
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
