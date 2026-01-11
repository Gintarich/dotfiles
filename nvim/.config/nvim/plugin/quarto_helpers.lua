local M = {}

---Is the current context a code chunk?
---@param lang string language of the code chunk
---@return boolean
M.is_code_chunk = function(lang)
  local current = require('otter.keeper').get_current_language_context()
  if current == lang then
    return true
  else
    return false
  end
end

--- Insert code chunk of given language
--- Splits current chunk if already within a chunk
--- @param lang string
--- @param curly boolean
M.insert_a_code_chunk = function(lang, curly)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
  local keys
  if curly == nil then
    curly = true
  end
  if M.is_code_chunk(lang) then
    if curly then
      keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
    else
      keys = [[o```<cr><cr>```]] .. lang .. [[<esc>o]]
    end
  else
    if curly then
      keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
    else
      keys = [[o```]] .. lang .. [[<cr>```<esc>O]]
    end
  end
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end

M.insert_code_chunk = function(lang)
  M.insert_a_code_chunk(lang, true)
end

M.insert_plain_code_chunk = function(lang)
  M.insert_a_code_chunk(lang, false)
end

M.insert_py_chunk = function()
  M.insert_code_chunk 'python'
end


M.new_terminal=function(lang)
  vim.cmd('vsplit term://' .. lang)
end
M.new_terminal_python=function()
  M.new_terminal('python')
end

M.new_terminal_ipython=function()
  M.new_terminal 'ipython --no-confirm-exit --no-autoindent'
end

M.new_terminal_shell = function()
  M.new_terminal '$SHELL'
end

vim.api.nvim_create_user_command('InsertPyChunk', function()
  M.insert_py_chunk()
end, {})

vim.api.nvim_create_user_command('NewPyTerm', function()
  M.new_terminal_ipython()
end, {})

return M
