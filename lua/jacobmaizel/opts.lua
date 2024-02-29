--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess= vim.opt.shortmess + { c = true}



-- vim.lsp.inlay_hint.enable(0, true)

-- vim.api.nvim_set_option('updatetime', 300) 

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
-- vim.cmd([[
-- autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
-- ]])


--   vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition)
--   vim.keymap.set("n", "K", vim.lsp.buf.hover)
--   vim.keymap.set("n", "gD", vim.lsp.buf.implementation)
--   vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help)
--   vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition)
--   vim.keymap.set("n", "gr", vim.lsp.buf.references)
--   vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol)
--   vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol)
--   vim.keymap.set("n", "gd", vim.lsp.buf.definition)
