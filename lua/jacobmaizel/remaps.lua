vim.g.mapleader = " "

vim.keymap.set('n', '<leader>lg', function()
  vim.cmd('LazyGit')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>clf', function()
  vim.lsp.codelens.refresh()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>clr', function()
  vim.lsp.codelens.run()
end, { noremap = true, silent = true })

