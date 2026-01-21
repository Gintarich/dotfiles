# AGENTS.md - Neovim Configuration

## Overview
Personal Neovim configuration written in Lua using [lazy.nvim](https://github.com/folke/lazy.nvim) as plugin manager. Main entry point: `init.lua`.

## Build/Lint/Test Commands

```bash
:source %           # Reload current file
<leader><leader>    # Reload current file
nvim --headless -c 'lua require("GB")' -c 'q'  # Test full config
:LspStart          # Start LSP diagnostics
:Lazy              # Open Lazy UI (sync/clean/update)
```

## Code Style

### Imports
- `require()` for module imports
- Main modules: `require('GB')`, `require('GB.lsp')`, `require('GB.set')`, `require('GB.remap')`
- Plugin specs: `require('GB.lazy.{plugin_name}')`

### Formatting
- 4 spaces for indentation
- No trailing whitespace
- Use `[[ ]]` for multiline strings
- `vim.api.nvim_create_autocmd` for autocommands

### Naming
- **Variables**: snake_case (e.g., `local venv_path`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `local LSP_ICONS = {...}`)
- **Leader key**: spacebar (`vim.g.mapleader = " "`)

### Keybindings
- Use `vim.keymap.set({mode}, keys, func, opts)` with `{desc}` field
- Prefix user keybindings with `<leader>`

### Error Handling
- `pcall(require, 'module')` for optional dependencies
- Graceful degradation: `enabled = false` for optional plugins

### Vim Options
- Use `vim.opt` (not `vim.o`)
- `vim.api.nvim_create_augroup()` for augroup management

## LSP Configuration

### Enabling Language Servers
```lua
vim.lsp.enable({
    "luals", "ts_ls", "cssls", "htmlls", "bashls", "basedpyright"
})
```

### LSP Keybindings (LspAttach autocmd)
- `gd` - goto definition
- `gr` - goto references
- `gI` - goto implementation
- `<leader>D` - type definition
- `<leader>ds` - document symbols
- `<leader>ws` - workspace symbols
- `<leader>rn` - rename

### LSP Diagnostics
```lua
vim.diagnostic.config({
    signs = { text = { [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error, ... } },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = { focusable = true, style = "minimal", border = "rounded" }
})
```

### Completion Kind Icons
```lua
local lsp_icons = {
    Class = " ", Function = "󰊕 ", Method = "ƒ ", Variable = " ", ...
}
```

## Autocomplete (cmp)

### Setup Pattern
```lua
require('cmp').setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' }
    },
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    }
})
```

## Treesitter

### Parser Installation
```bash
:TSInstall sql json lua bash html javascript
: python cssTSUpdate    # Update parsers
:TSBufEnable {lang}    # Enable for buffer
```

### Treesitter Configuration
- Used for syntax highlighting, indentation, folds
- `:TSPlaygroundToggle` - visualizer
- `:Inspect` - highlight groups under cursor

## File Structure
```
nvim/.config/nvim/
├── init.lua              # Entry point
├── lazy-lock.json        # Auto-generated
├── lua/
│   ├── GB/
│   │   ├── init.lua      # Main init
│   │   ├── lsp.lua       # LSP setup
│   │   ├── set.lua       # Vim options
│   │   ├── remap.lua     # Keybindings
│   │   ├── incons.lua    # Icons
│   │   └── lazy/         # Plugin specs
│   └── utils/            # Utilities
├── lsp/                  # LSP server configs
├── plugin/               # Plugin configs
└── after/                # Filetype plugins
```

## Dependencies
- Neovim 0.9+ (0.10+ recommended)
- lua-language-server (luals)
- lazy.nvim
- ripgrep, fd (for Telescope)
