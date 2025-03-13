local tele = require('telescope.builtin')

function Grep_str()
  return tele.grep_string({ search = vim.fn.input("Grep For > ") })
end

function Grep_cword()
  return tele.grep_string({ search = vim.fn.expand("<cword>")})
end

local args = {noremap=true, silent=true}

function FindHidden()
  return tele.find_files({hidden=true})
end

vim.keymap.set('n', '<leader>hf', tele.find_files, args )
vim.keymap.set('n', '<leader>f', FindHidden, args )
vim.keymap.set('n', '<leader>g', tele.live_grep, args)
vim.keymap.set('n', '<leader>b', tele.buffers, args)
vim.keymap.set('n', '<leader>ht', tele.help_tags, args)
vim.keymap.set('n', '<leader>d', tele.lsp_document_symbols, args)
vim.keymap.set('n', '<leader>w', tele.lsp_workspace_symbols, args)
vim.keymap.set('n', '<leader>im', tele.lsp_implementations, args)
vim.keymap.set('n', '<leader>ps', Grep_str, args)
vim.keymap.set('n', '<leader>cw', Grep_cword, args)
