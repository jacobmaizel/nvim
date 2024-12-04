local builtin = require('telescope.builtin')

function Grep_str()
  return builtin.grep_string({ search = vim.fn.input("Grep For > ") })
end

function Grep_cword()
  return builtin.grep_string({ search = vim.fn.expand("<cword>")})
end

vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>ht', builtin.help_tags, {})
vim.keymap.set('n', '<leader>d', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>w', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>ps', Grep_str, {})
vim.keymap.set('n', '<leader>cw', Grep_cword, {})
