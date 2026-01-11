
vim.g.slime_target = "neovim"
vim.g.slime_bracketed_paste = 1


--- Send code to terminal with vim-slime
--- If an R terminal has been opend, this is in r_mode
--- and will handle python code via reticulate when sent
--- from a python chunk.
--- TODO: incorpoarate this into quarto-nvim plugin
--- such that QuartoSend functions get the same capabilities
--- TODO: figure out bracketed paste for reticulate python repl.
local function send_cell()
  local has_molten, molten_status = pcall(require, 'molten.status')
  local molten_works = false
  local molten_active = ''
  if has_molten then
    molten_works, molten_active = pcall(molten_status.kernels)
  end
  if molten_works and molten_active ~= vim.NIL and molten_active ~= '' then
    molten_active = molten_status.initialized()
  end
  if molten_active ~= vim.NIL and molten_active ~= '' and molten_status.kernels() ~= 'Molten' then
    vim.cmd.QuartoSend()
    return
  end

  if vim.b['quarto_is_r_mode'] == nil then
    vim.fn['slime#send_cell']()
    return
  end
  if vim.b['quarto_is_r_mode'] == true then
    vim.g.slime_python_ipython = 0
    local is_python = require('otter.tools.functions').is_otter_language_context 'python'
    if is_python and not vim.b['reticulate_running'] then
      vim.fn['slime#send']('reticulate::repl_python()' .. '\r')
      vim.b['reticulate_running'] = true
    end
    if not is_python and vim.b['reticulate_running'] then
      vim.fn['slime#send']('exit' .. '\r')
      vim.b['reticulate_running'] = false
    end
    vim.fn['slime#send_cell']()
  end
end

--- Send code to terminal with vim-slime
--- If an R terminal has been opend, this is in r_mode
--- and will handle python code via reticulate when sent
--- from a python chunk.
local slime_send_region_cmd = ':<C-u>call slime#send_op(visualmode(), 1)<CR>'
slime_send_region_cmd = vim.api.nvim_replace_termcodes(slime_send_region_cmd, true, false, true)
local function send_region()
  -- if filetyps is not quarto, just send_region
  if vim.bo.filetype ~= 'quarto' or vim.b['quarto_is_r_mode'] == nil then
    vim.cmd('normal' .. slime_send_region_cmd)
    return
  end
  if vim.b['quarto_is_r_mode'] == true then
    vim.g.slime_python_ipython = 0
    local is_python = require('otter.tools.functions').is_otter_language_context 'python'
    if is_python and not vim.b['reticulate_running'] then
      vim.fn['slime#send']('reticulate::repl_python()' .. '\r')
      vim.b['reticulate_running'] = true
    end
    if not is_python and vim.b['reticulate_running'] then
      vim.fn['slime#send']('exit' .. '\r')
      vim.b['reticulate_running'] = false
    end
    vim.cmd('normal' .. slime_send_region_cmd)
  end
end

-- send code with ctrl+Enter
-- just like in e.g. RStudio
-- needs kitty (or other terminal) config:
-- map shift+enter send_text all \x1b[13;2u
-- map ctrl+enter send_text all \x1b[13;5u
local nmap = function(key, effect, desc)
  vim.keymap.set('n', key, effect, { silent = true, noremap = true, desc = desc })
end

local vmap = function(key, effect, desc)
  vim.keymap.set('v', key, effect, { silent = true, noremap = true, desc = desc })
end

local imap = function(key, effect, desc)
  vim.keymap.set('i', key, effect, { silent = true, noremap = true, desc = desc })
end

local cmap = function(key, effect, desc)
  vim.keymap.set('c', key, effect, { silent = true, noremap = true, desc = desc })
end
nmap('<c-cr>', send_cell)
nmap('<s-cr>', send_cell)
imap('<c-cr>', send_cell)
imap('<s-cr>', send_cell)

-- Move between windows using <ctrl> direction
nmap('<C-j>', '<C-W>j')
nmap('<C-k>', '<C-W>k')
nmap('<C-h>', '<C-W>h')
nmap('<C-l>', '<C-W>l')

-- Resize window using <shift> arrow keys
nmap('<S-Up>', '<cmd>resize +2<CR>')
nmap('<S-Down>', '<cmd>resize -2<CR>')
nmap('<S-Left>', '<cmd>vertical resize -2<CR>')
nmap('<S-Right>', '<cmd>vertical resize +2<CR>')

nmap( '<leader>qp', "<cmd>InsertPyChunk<CR>", 'python code chunk' )
nmap( "<leader>qc", "<cmd>SlimeConfig<cr>", "Slime: configure target")
nmap( "<leader>ql", "<cmd>SlimeSendCurrentLine<cr>", "Slime: send line")
nmap( "<leader>qs", "<cmd>SlimeSend<cr>", "Slime: send selection")
vmap( "<leader>qs", "<cmd>QuartoSendRange<cr>", "Slime: send paragraph")
nmap( "<leader>qt", "<cmd>NewPyTerm<CR>", "Slime: send paragraph")

-- Optional: send the current *Quarto chunk* if quarto-nvim is installed
do
  local ok, runner = pcall(require, "quarto.runner")
  if ok then
    nmap( "<leader>qr", runner.run_cell, "Quarto: run chunk (via Slime)")
    nmap( "<leader>qR", runner.run_all, "Quarto: run all (via Slime)")
  end
end

-- --- WhichKey: pretty menu (buffer-local) ---
do
  local ok, wk = pcall(require, "which-key")
if ok then
    wk.add({
      { "<leader>q", group = "Quarto", buffer = 0 },
      { "<leader>qc", desc = "Configure target", buffer = 0 },
      { "<leader>ql", desc = "Send line", buffer = 0 },
      { "<leader>qs", desc = "Send selection", mode = "v", buffer = 0 },
      { "<leader>qp", desc = "Send paragraph", buffer = 0 },
      { "<leader>qr", desc = "Run chunk (qmd)", buffer = 0 },
      { "<leader>qR", desc = "Run all (qmd)", buffer = 0 },
    })
  end
end
