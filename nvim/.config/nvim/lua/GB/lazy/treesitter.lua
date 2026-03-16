return {
  'nvim-treesitter/nvim-treesitter',
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require('nvim-treesitter')
    local parsers = {
      "c", "cpp", "c_sharp", "lua", "vim", "vimdoc",
      "markdown", "markdown_inline", "bash", "regex",
      "latex", "html", "css", "javascript", "python",
    }

    if type(treesitter.install) == "function" then
      treesitter.setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })

      treesitter.install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
        desc = 'Start treesitter highlighting',
      })

      return
    end

    require('nvim-treesitter.configs').setup({
      ensure_installed = parsers,
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
