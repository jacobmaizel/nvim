local args = {noremap=true, silent=true}
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, args)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, args)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end, args)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end, args)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end, args)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, args)

