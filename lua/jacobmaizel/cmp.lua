local types = require("cmp.types")

-- General keymaps
vim.keymap.set("n", "<leader>y", function()
	vim.fn.setreg("*", vim.fn.expand("<cword>"))
end)

vim.keymap.set("v", "<leader>r", function()
	local r = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
	vim.fn.setreg("*", r)
	local keys = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
	vim.api.nvim_feedkeys(keys, "m", false)
end)

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = { "*.json" },
--   callback = function()
--     vim.cmd "Prettier"
--   end
-- })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.diagnostic.config({
	float = { border = "rounded" },
})

local shared_on_attach = function(client, bufnr)
	-- you can also put keymaps in here
	-- print("attached go a buffer, setting keymaps")

	local keymap_opts = { buffer = bufnr }
	-- Code navigation and shortcuts
	vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
	vim.keymap.set("n", "<c-s>", vim.lsp.buf.signature_help, keymap_opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, keymap_opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
	vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
	vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, keymap_opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, keymap_opts)
	vim.keymap.set("n", "<leader>ll", vim.diagnostic.setloclist, keymap_opts)
	vim.keymap.set("n", "<leader>u", function()
		vim.lsp.buf.format({ async = false })
	end, keymap_opts)

	-- vim.api.nvim_set_keymap('n', '<leader>cd', ':lua Copilot disable<CR>', keymap_opts)
	-- vim.api.nvim_set_keymap('n', '<leader>ce', ':lua Copilot enable<CR>', keymap_opts)
	vim.keymap.set("n", "<leader>cod", function()
		vim.cmd("Copilot disable")
	end, keymap_opts)

	vim.keymap.set("n", "<leader>coe", function()
		vim.cmd("Copilot enable")
	end, keymap_opts)

	vim.keymap.set("n", "<leader>iht", function()
		-- vim.lsp.inlay_hint.enable(bufnr, true)
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, keymap_opts)

	-- vim.keymap.set('n', '<leader>ihd', function()
	--   vim.lsp.inlay_hint.enable(bufnr, false)
	-- end, keymap_opts)

	vim.opt.updatetime = 299

	-- Goto previous/next diagnostic warning/error
	vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
	vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
	vim.keymap.set("n", "<leader>t", vim.diagnostic.open_float, keymap_opts)
end

local set_auto_formatter_pre_write_python = function(client, bufnr)
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function()
			-- vim.cmd "!ruff check --fix --select I"
			vim.lsp.buf.format({ async = false })
		end,
	})
end

local eslint_on_attach = function(client, bufnr)
	shared_on_attach(client, bufnr)

	-- vim.api.nvim_create_autocmd("BufWritePre", {
	--   buffer = bufnr,
	--   command = "EslintFixAll",
	-- })

	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function()
			vim.cmd("EslintFixAll")
			vim.cmd("Prettier")
		end,
	})

	-- vim.api.nvim_create_autocmd("BufWritePre", {
	--   buffer = bufnr,
	--   command = "Prettier",
	-- })
end

-- Overridden compare.kind function
-- This is a custom comparator that will sort the completion items by kind
-- This ensures that variables are at the top of the list, and snippets are at the bottom
local override_compare_kind = function(entry1, entry2)
	local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
	local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number

	-- Prioritize variables over everything
	if kind1 == types.lsp.CompletionItemKind.Variable then
		return true
	end
	if kind2 == types.lsp.CompletionItemKind.Variable then
		return false
	end

	-- Handle Text kind by assigning a high value to push them towards the bottom
	kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
	kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2

	-- Deprioritize snippets to be at the bottom
	if kind1 == types.lsp.CompletionItemKind.Snippet then
		return false
	end
	if kind2 == types.lsp.CompletionItemKind.Snippet then
		return true
	end

	-- General sort by kind for other types
	local diff = kind1 - kind2
	if diff < 0 then
		return true
	elseif diff > 0 then
		return false
	end

	return nil
end

---kind: Entires with smaller ordinal value of 'kind' will be ranked higher.
---(see lsp.CompletionItemKind enum).
---Exceptions are that Text(1) will be ranked the lowest, and snippets be the highest.
---@type cmp.ComparatorFunction

local kind_compare_override = function(entry1, entry2)
	local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
	local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
	kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
	kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
	if kind1 ~= kind2 then
		if kind1 == types.lsp.CompletionItemKind.Snippet then
			return false
		end
		if kind2 == types.lsp.CompletionItemKind.Snippet then
			return true
		end
		local diff = kind1 - kind2
		if diff < 0 then
			return true
		elseif diff > 0 then
			return false
		end
	end
	return nil
end

-- Set up nvim-cmp.
local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

local select_opts = { behavior = cmp.SelectBehavior.Select }

-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
-- list of advanced mappings from the man himself
cmp.setup({
	preselect = cmp.PreselectMode.None,
	completion = { completeopt = "noselect" },

	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			require("cmp-under-comparator").under,
			-- cmp.config.compare.kind,
			kind_compare_override,
		},
	},

	formatting = {
		-- Youtube: How to set up nice formatting for your sources.
		fields = { "menu", "abbr", "kind" },
		format = lspkind.cmp_format({
			with_text = true,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[api]",
				path = "[path]",
				luasnip = "[snip]",
				gh_issues = "[issues]",
				tn = "[TabNine]",
				eruby = "[erb]",
			},
		}),
	},

	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- good reference for mappings
	--
	-- https://www.reddit.com/r/neovim/comments/11wo0a3/having_trouble_with_lsp_and_cmp_completing/

	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

		["<Tab>"] = cmp.mapping(function(fallback)
			local col = vim.fn.col(".") - 1

			if cmp.visible() then
				cmp.select_next_item(select_opts)
			elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
				fallback()
			else
				cmp.complete()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item(select_opts)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-f>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-b>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- from language server
		{ name = "nvim_lua" },
		{ name = "copilot" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "luasnip", max_item_count = 8 },
	}, {
		{ name = "path" },
		{ name = "buffer" },
	}),
})

cmp.setup.filetype("toml", {
	sources = cmp.config.sources({
		{ name = "crates" },
	}, {
		{ name = "buffer" },
	}),
})

-- Set configuration for specific filetype.
--   cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--       { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
--     }, {
--       { name = 'buffer' },
--     })
--   })

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- This way is deprecated, use the default_capabilities instead
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require("lspconfig")["lua_ls"].setup({
	capabilities = capabilities,
	filetypes = { "lua" },
	on_attach = shared_on_attach,
	settings = {
		Lua = {
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
		},
	},
})
-- ↓ eslint.autoFixOnSave                   default: false
--   Turns auto fix on save on or off.
--   type boolean
-- → eslint.codeAction.disableRuleComment
-- → eslint.codeAction.showDocumentation
-- → eslint.codeActionsOnSave.mode          default: "all"
-- → eslint.codeActionsOnSave.rules
-- → eslint.debug                           default: false
-- → eslint.enable                          default: true
-- → eslint.execArgv
-- → eslint.experimental.useFlatConfig      default: false
-- ↓ eslint.format.enable                   default: false
--
require("lspconfig")["eslint"].setup({
	capabilities = capabilities,
	on_attach = shared_on_attach,
	-- filetypes = {"ts", "tsx", "js", "jsx", "typescript", "javascript", "javascriptreact", "typescriptreact"},
	-- flags = { debounce_text_changes = 500 },
	settings = {
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
		codeActionOnSave = {
			enable = true,
			mode = "all",
		},
		experimental = {
			useFlatConfig = false,
		},
		format = {
			enable = true,
		},
		nodePath = "",
		onIgnoredFiles = "off",
		problems = {
			shortenToSingleLine = false,
		},
		quiet = false,
		rulesCustomizations = {},
		run = "onType",
		useESLintClass = false,
		validate = "on",
		workingDirectory = {
			mode = "location",
		},
	},
})
require("lspconfig")["bzl"].setup({
	capabilities = capabilities,
	on_attach = shared_on_attach,
	filetypes = { "starlark", "Tiltfile" },
})

local pyright_on_attach = function(client, bufnr)
	shared_on_attach(client, bufnr)
end

-- NOTE notes on how to adjust the duplicate tagged hints thing for unused variables
-- https://github.com/astral-sh/ruff-lsp/issues/384

require("lspconfig")["pyright"].setup({
	capabilities = capabilities,
	-- capabilities = capabilities,
	-- capabilities = (function()
	--           local capabilities = vim.lsp.protocol.make_client_capabilities()
	--           capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
	--           return capabilities
	--         end)(),
	on_attach = pyright_on_attach,
	settings = {
		pyright = {
			-- Using Ruff's import organizer
			disableOrganizeImports = true,
			disableTaggedHints = true,

			-- capabilities = {
			--     textDocument = {
			--       publishDiagnostics = {
			--         tagSupport = {
			--           valueSet = { 2 },
			--         },
			--       },
			--     },
			--   },
		},
		python = {
			analysis = {
				-- Ignore all files for analysis to exclusively use Ruff for linting
				-- ignore = { '*' },
				-- typeCheckingMode = 'off'
			},
		},
	},
})

-- https://github.com/astral-sh/ruff-lsp/issues/119
-- https://www.reddit.com/r/neovim/comments/1ans7qi/code_action_on_save/

-- Auto run a code action
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- callback = function()
-- if vim.bo.ft == "python" then
-- vim.lsp.buf.code_action {
-- context = { only = { "source.fixAll.ruff" } },
-- apply = true,
-- }
-- end
-- end,
-- })
--


-- require("lspconfig")["open-policy-agent"].setup({
-- 	capabilities = capabilities,
-- 	on_attach = shared_on_attach,
-- 	filetypes = { "rego" },
-- })

require("lspconfig").ruff.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		shared_on_attach(client, bufnr)

		set_auto_formatter_pre_write_python(client, bufnr)
	end,
	-- init_options = {
	--   settings = {
	--     -- Any extra CLI arguments for `ruff` go here.
	--     args = {},
	--   }
	-- }
})

require("lspconfig")["zls"].setup({
	capabilities = capabilities,
	on_attach = shared_on_attach,
})

require("lspconfig")["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = shared_on_attach,
	filetypes = { "ts", "tsx", "js", "jsx", "typescript", "javascript", "javascriptreact", "typescriptreact", "mdx" },
})

require("lspconfig")["ts_ls"].setup({
	capabilities = capabilities,
	on_attach = shared_on_attach,
	settings = {
		typescript = {
			format = {
				enable = false,
			},
			inlayHints = {
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayVariableTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayVariableTypeHints = true,

				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
})

-- require('lspconfig')['sqls'].setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

local lspconfig = require("lspconfig")
-- local util = require "lspconfig/util"

-- https://github.com/golangci/golangci-lint/blob/master/.golangci.reference.yml

-- this is not working until we figure out what format it wants the glue functions in...
-- require('lspconfig').cucumber_language_server.setup {
--   capabilities = capabilities,
--   on_attach = shared_on_attach,
--   settings = {
--     cucumber = {
--       features = { "**/*.feature" },
--       glue = { "*specs*/**/*.cs",
--         "features/**/*.js",
--         "features/**/*.jsx",
--         "features/**/*.php",
--         "features/**/*.py",
--         "features/**/*.rs",
--         "features/**/*.rb",
--         "features/**/*.ts",
--         "features/**/*.tsx",
--         "features/**/*_test.go",
--         "packages/demo/features_test.go",
--         "src/test/**/*.java",
--         "tests/**/*.py",
--         "tests/**/*.rs"
--       },
--     },
--   },
-- }

require("lspconfig").yamlls.setup({
	filetypes = { "yaml", "yml" },
	capabilities = capabilities,
	-- on_attach = shared_on_attach,
	on_attach = function(client, bufnr)
		shared_on_attach(client, bufnr)
		-- client.resolved_capabilities.document_formatting = true
	end,
	settings = {
		yaml = {
			completion = true,
			validate = true,
			hover = true,

			format = {
				enable = true,
			},
			schemaStore = {
				enable = true,
			},
		},
	},
})

require("lspconfig").dockerls.setup({
	capabilities = capabilities,
	on_attach = shared_on_attach,
})

require("lspconfig").golangci_lint_ls.setup({
	filetypes = { "go", "gomod" },

	capabilities = capabilities,
	on_attach = shared_on_attach,
})

-- import / code formatting for go https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports-and-formatting
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.go" },
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		-- buf_request_sync defaults to a 1000ms timeout. Depending on your
		-- machine and codebase, you may want longer. Add an additional
		-- argument after params if you find that you have to write the file
		-- twice for changes to be saved.
		-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end,
})

-- https://github.com/caarlos0/dotfiles/blob/39234246260f067e571d88174a2c624928e93a8c/modules/neovim/config/lua/user/lsp.lua#L58
require("lspconfig")["gopls"].setup({
	capabilities = capabilities,
	on_attach = shared_on_attach,
	-- cmd = { "gopls" },
	-- filetypes = { "go", "gomod", "gowork", "gotmpl" },
	-- root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			hints = {
				["parameterNames"] = true,
				["compositeLiteralFields"] = true,
				["compositeLiteralTypes"] = true,
				["constantValues"] = true,
				["rangeVariableTypes"] = true,
				["functionTypeParameters"] = true,
				["assignVariableTypes"] = true,
			},
			-- https://github.com/golang/tools/blob/master/gopls/doc/codelenses.md
			codelenses = {
				gc_details = true,
				generate = true,
				govulncheck = true,
				test = true,
				tidy = true,
				-- upgrade_dependency = true,
			},
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedvariable = true,
				unusedwrite = true,
				useany = true,
			},
			staticcheck = true,
			gofumpt = true,
			semanticTokens = true,
		},
	},
	flags = {
		debounce_text_changes = 150,
	},
})
