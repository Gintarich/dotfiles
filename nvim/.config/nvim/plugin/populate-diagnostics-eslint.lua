local function eslint_project(opts)
  opts = opts or {}
  local bufname = vim.api.nvim_buf_get_name(0)
  local start = (bufname ~= "" and bufname) or vim.loop.cwd()
  local root = vim.fs.root(start,
    { "eslint.config.mjs", ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", "package.json", ".git" })
  root = root or vim.loop.cwd()
  local target = opts.target or "." -- change to "app src" if you prefer
  local cmd = {
    "npx",
    "--no-install",
    "eslint",
    "--no-color",
    "-f",
    "unix",
    "--ext",
    ".js,.jsx,.ts,.tsx",
    "--ignore-pattern",
    ".next/**",
    target,
  }
  local efm = "%A%f:%l:%c:%m,%-G%.%#"
  local function set_qf(output)
    output = output or ""
    output = vim.trim(output)
    local lines = (output == "") and {} or vim.split(output, "\n", { plain = true })
    vim.fn.setqflist({}, " ", {
      title = "ESLint (" .. root .. ")",
      lines = lines,
      efm = efm,
    })
    if #lines > 0 then vim.cmd("copen") end
  end
  -- Neovim 0.10+: vim.system
  if vim.system then
    vim.system(cmd, { cwd = root, text = true }, function(res)
      local out = (res.stdout or "") .. (res.stderr or "")
      vim.schedule(function() set_qf(out) end)
    end)
    return
  end
  -- Fallback for older Neovim: jobstart
  local chunks = {}
  vim.fn.jobstart(cmd, {
    cwd = root,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data) if data then vim.list_extend(chunks, data) end end,
    on_stderr = function(_, data) if data then vim.list_extend(chunks, data) end end,
    on_exit = function()
      vim.schedule(function() set_qf(table.concat(chunks, "\n")) end)
    end,
  })
end
vim.api.nvim_create_user_command("EslintProject", function()
  eslint_project({ target = "." })
end, {})
