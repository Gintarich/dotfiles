# AGENTS.md - Neovim Configuration Repository

## Overview
This is a personal Neovim configuration repository (dotfiles) written in Lua. It uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. The config is located at `nvim/.config/nvim/` with the main entry point in `init.lua`.

## Build/Lint/Test Commands

### Reloading Neovim Configuration
To test changes without restarting Neovim:
```bash
:source %
```
Or use the keybinding `<leader><leader>` to reload the current file.

### Lua Syntax/Lint Checking
This repo uses lua-language-server (luals) for linting and diagnostics. Key checks:
- `vim.lsp.start({...})` - Start LSP diagnostics manually
- Use `:checkhealth lsp` to verify LSP configuration

### Shell Script Testing
The repository contains setup scripts in `scripts/`:
```bash
./scripts/testRunner.sh    # Tests zsh installation
./scripts/testscript.sh    # Sample bash array test
./scripts/install-packages.sh  # Package installation
```

### Plugin Manager Commands
```bash
:Lazy          # Open Lazy UI to manage plugins
:Lazy sync     # Sync all plugins
:Lazy clean    # Remove unused plugins
:Lazy update   # Update all plugins
```

## Code Style Guidelines

### Lua Style Conventions

#### Imports
- Use `require()` for module imports (e.g., `require('GB.lsp')`)
- Modules are located under `lua/` directory
- Relative imports use dot notation: `require('GB.lazy.autocomplete')`
- Avoid Lua's `module()` pattern; prefer explicit returns

#### Formatting
- Use 4 spaces for indentation (soft tabs)
- No trailing whitespace
- Use `[[ ]]` for multiline strings with literal content
- Use `vim.api.nvim_create_autocmd` for autocommands (not deprecated `autocmd`)
- Use `vim.keymap.set()` for mappings with `{desc}` field for documentation

#### Naming Conventions
- **Variables**: snake_case (e.g., `local venv_path`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `local LSP_ICONS = {...}`)
- **Modules/Files**: snake_case with descriptive names (e.g., `lsp.lua`, `autocomplete.lua`)
- **Groups/Augroups**: descriptive names (e.g., `'highlight-yank'`)
- **Keybinding leaders**: `<leader>` is set to spacebar
- **Buffer-local variables**: `vim.b.{varname}`
- **Global variables**: `vim.g.{varname}`

#### Keybindings
- Use `<leader>` prefix for user keybindings
- Include `{desc}` option for documentation
- Use `vim.keymap.set({mode}, keys, func, opts)`
- Modes: `'n'` (normal), `'v'` (visual), `'i'` (insert), `'x'` (visual block)

#### Error Handling
- Use `pcall(require, 'module')` for optional dependencies
- Check `vim.fn.expand()` for path operations
- Use `vim.env` for environment variables
- Graceful degradation: `enabled = false` for optional plugins

#### LSP Configuration
- Use `vim.lsp.enable({...})` to enable language servers
- Define icons tables for completion kinds
- Use `vim.diagnostic.config()` for diagnostics setup
- Autocommands use `'LspAttach'` event for LSP-related keybindings

#### Plugin Configuration
- Plugins configured as Lua tables with `opts` field
- Use return tables for lazy plugin specs
- Plugin specs include `ft` (filetype) for filetype-specific plugins
- Disabled plugins set `enabled = false`

#### Vim Options
- Use `vim.opt` for options (not `vim.o`)
- Use `vim.api.nvim_create_augroup()` for augroup management
- Use `vim.env.VIRTUAL_ENV` for Python virtual environments

#### File Structure
```
nvim/.config/nvim/
├── init.lua              # Entry point
├── lazy-lock.json        # Lock file (DO NOT edit manually)
├── lua/
│   ├── GB/              # Main config modules
│   │   ├── init.lua
│   │   ├── lsp.lua
│   │   ├── set.lua
│   │   ├── remap.lua
│   │   ├── lazy/
│   │   │   ├── init.lua
│   │   │   ├── autocomplete.lua
│   │   │   ├── lualsp.lua
│   │   │   └── ...
│   │   └── incons.lua
│   └── utils/
│       ├── init.lua
│       └── csharp_utils.lua
├── lsp/                  # LSP server configs
├── plugin/               # Plugin-specific configs
└── after/                # Filetype plugins
```

#### Comments
- Use `--` for single-line comments
- Add descriptions for autocommands: `desc = '...'`
- Document complex logic with inline comments
- Remove commented-out code if not temporarily debugging

#### Paths
- Use `vim.fn.expand()` for path expansion
- Home directory: `os.getenv("HOME")` or `~`
- Store undo files in `~/.vim/undodir`

## Development Workflow

1. Make changes to Lua files
2. Reload with `:source %` or `<leader><leader>`
3. Verify in Neovim
4. Update `lazy-lock.json` automatically by Lazy

## Key Dependencies
- Neovim 0.9+ (recommended 0.10+)
- lua-language-server (luals)
- lazy.nvim (plugin manager)
- ripgrep (for Telescope)
- fd (file finder)

## Useful Commands
```bash
nvim --headless -c 'lua require("GB")' -c 'q'  # Test config headless
nvim -u NONE -c 'luafile init.lua'  # Test with minimal config
```

## Notes
- This is a personal configuration - prioritize consistency over external conventions
- Comment keybindings with descriptive `{desc}` fields
- Keep `:checkhealth` clean and passing
- Test plugin changes before committing
