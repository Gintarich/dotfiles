
-- ~/.config/nvim/plugin/open_in_browser.lua
-- Commands:
--   :OpenInBrowser          -> open current file as file:// URL
--   :OpenInLiveServer [port] -> open current file via live-server (default 5500)

local M = {}

local function spawn(cmd)
  -- Neovim 0.10+: vim.system; older: jobstart
  if vim.system then
    return vim.system(cmd, { detach = true })
  else
    vim.fn.jobstart(cmd, { detach = true })
    return nil
  end
end

local function open_url(url)
  if vim.fn.has('mac') == 1 then
    spawn({ 'open', url })
  elseif vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    spawn({ 'cmd', '/c', 'start', '', url })
  else
    if vim.fn.executable('wslview') == 1 then
      spawn({ 'wslview', url })
    else
      spawn({ 'xdg-open', url })
    end
  end
end

local function url_encode(path)
  -- Encode all non-safe URL chars but keep slashes
  print(path)
  return (path:gsub("[^%w%-%._~/]", function(c)
    return string.format("%%%02X", string.byte(c))
  end))
end

local function project_root()
  -- 1) LSP root if available
  if vim.lsp and vim.lsp.get_active_clients then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local root = client.config and client.config.root_dir or nil
      if root and #root > 0 then return root end
    end
  end
  -- 2) git root
  local out = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })
  if vim.v.shell_error == 0 and out and out[1] and #out[1] > 0 then
    return out[1]
  end
  -- 3) fall back to current file's directory
  return vim.fn.expand('%:p:h')
end

function M.open_file_in_browser()
  local path = vim.fn.expand('%:p')
  -- file:// works across platforms; browsers reuse the current app instance
  open_url(vim.uri_from_fname(path))
end

-- Keep a tiny registry so we don't spawn multiple servers per root
local servers = {}  -- key = root, val = { port = number }

local function ensure_live_server(root, port)
  -- Prefer globally installed live-server; otherwise use npx (project/local).
  local cmd
  if vim.fn.executable('live-server') == 1 then
    cmd = { 'live-server', '--no-browser', '--port=' .. port, root }
  elseif vim.fn.executable('npx') == 1 then
    cmd = { 'npx', '-y', 'live-server', '--no-browser', '--port=' .. port, root }
  else
    vim.notify(
      'Install "live-server" (npm i -g live-server) or have npx available.',
      vim.log.levels.ERROR
    )
    return false
  end
  if not servers[root] then
    spawn(cmd)                    -- detached background process
    servers[root] = { port = port }
    -- Small delay gives the server time to bind; not strictly required.
    vim.defer_fn(function() end, 150)
  end
  return true
end

local function relpath(file, root)
  if vim.fs and vim.fs.relpath then
    return vim.fs.relpath(root, file)
  end
  -- Fallback: strip prefix with either / or \
  local esc = vim.pesc(root)
  local stripped = file:gsub('^' .. esc .. '[\\/]*', '')
  return stripped
end

function M.open_in_live_server(port_opt)
  local root = project_root()
  local port = tonumber(port_opt) or 5500

  if not ensure_live_server(root, port) then return end

  local file = vim.fn.expand('%:p')
  local rel  = relpath(file, root)
  local url  = ('http://127.0.0.1:%d/%s'):format(port, url_encode(rel))
  -- Using --no-browser when starting the server prevents it from opening a new window.
  -- We open the URL ourselves; the browser uses the existing app instance (new tab).
  print("This is url : " .. url)
  open_url(url)
end

vim.api.nvim_create_user_command('OpenInBrowser', function()
  M.open_file_in_browser()
end, {})

vim.api.nvim_create_user_command('OpenInLiveServer', function(opts)
  M.open_in_live_server(opts.args)
end, { nargs = '?' })

-- Handy keymaps (optional)
vim.keymap.set('n', '<leader>hb', function() vim.cmd.write(); M.open_file_in_browser() end,
  { desc = 'Open current file in default browser' })

vim.keymap.set('n', '<leader>hl', function() vim.cmd.write(); M.open_in_live_server() end,
  { desc = 'Open current file via live-server (port 5500)' })

return M
