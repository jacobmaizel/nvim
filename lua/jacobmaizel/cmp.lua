local types = require('cmp.types')

local on_attach = function(client, bufnr)
    -- you can also put keymaps in here
    -- print("attached go a buffer, setting keymaps")

    local keymap_opts = { buffer = bufnr }
-- Code navigation and shortcuts
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
    vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
    vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
    vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
    vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, keymap_opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, keymap_opts)
    vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist, keymap_opts)
    vim.keymap.set('n', '<leader>u', function() vim.lsp.buf.format { async = true } end, keymap_opts)



    -- vim.api.nvim_set_keymap('n', '<leader>cd', ':lua Copilot disable<CR>', keymap_opts)
    -- vim.api.nvim_set_keymap('n', '<leader>ce', ':lua Copilot enable<CR>', keymap_opts)
    vim.keymap.set('n', '<leader>cod', function()
      vim.cmd('Copilot disable')
    end, keymap_opts)

    vim.keymap.set('n', '<leader>coe', function()
      vim.cmd('Copilot enable')
    end, keymap_opts)

    vim.keymap.set('n', '<leader>ihe', function()
      vim.lsp.inlay_hint.enable(bufnr, true)
    end, keymap_opts)

    vim.keymap.set('n', '<leader>ihd', function()
      vim.lsp.inlay_hint.enable(bufnr, false)
    end, keymap_opts)

    vim.opt.updatetime = 299

    -- Goto previous/next diagnostic warning/error
    vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
    vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
    vim.keymap.set("n", "<leader>t", vim.diagnostic.open_float, keymap_opts)


end



local eslint_on_attach = function(client, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
end

-- Overridden compare.kind function
-- This is a custom comparator that will sort the completion items by kind
-- This ensures that variables are at the top of the list, and snippets are at the bottom
local override_compare_kind = function(entry1, entry2)
  local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
  local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number

  -- Prioritize variables over everything
  if kind1 == types.lsp.CompletionItemKind.Variable then return true end
  if kind2 == types.lsp.CompletionItemKind.Variable then return false end

  -- Handle Text kind by assigning a high value to push them towards the bottom
  kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
  kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2

  -- Deprioritize snippets to be at the bottom
  if kind1 == types.lsp.CompletionItemKind.Snippet then return false end
  if kind2 == types.lsp.CompletionItemKind.Snippet then return true end

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
  local cmp = require'cmp'
  local lspkind = require('lspkind')
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
    format = lspkind.cmp_format {
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
    },
  },
  snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },

    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    sources = cmp.config.sources({
        { name = 'nvim_lsp'},      -- from language server
        { name = 'nvim_lua'},
        { name = 'copilot'},
        { name = 'nvim_lsp_signature_help'},
        { name = 'luasnip', max_item_count = 4},
      }, {
        { name = 'path' },
        { name = 'buffer'},
      }),

  })

  cmp.setup.filetype('toml', {
    sources = cmp.config.sources({
      { name = 'crates' },
    }, {
      { name = 'buffer' },
    })
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
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['lua_ls'].setup {
    capabilities = capabilities,
    filetypes = {"lua"},
    on_attach = on_attach,
     settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
      },
    },
  }
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
  require('lspconfig')['eslint'].setup {
    capabilities = capabilities,
    on_attach = eslint_on_attach ,
    -- filetypes = {"ts", "tsx", "js", "jsx", "typescript", "javascript", "javascriptreact", "typescriptreact"},
    -- flags = { debounce_text_changes = 500 },
    settings = {
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = "separateLine"
          },
          showDocumentation = {
            enable = true
          }
        },
        codeActionOnSave = {
          enable = true,
          mode = "all"
        },
        experimental = {
          useFlatConfig = false
        },
        format = true,
        nodePath = "",
        onIgnoredFiles = "off",
        problems = {
          shortenToSingleLine = false
        },
        quiet = false,
        rulesCustomizations = {},
        run = "onType",
        useESLintClass = false,
        validate = "on",
        workingDirectory = {
          mode = "location"
        }
      }
  }
  require('lspconfig')['bzl'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {"starlark", "Tiltfile"},
  }

  require('lspconfig')['pyright'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
        typeCheckingMode = 'off'
      },
    },
  },
  }

-- https://github.com/astral-sh/ruff-lsp/issues/119

  require('lspconfig').ruff_lsp.setup {
    capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}

  require('lspconfig')['tailwindcss'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {"ts", "tsx", "js", "jsx", "typescript", "javascript", "javascriptreact", "typescriptreact", "mdx"},
  }

  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
     settings = {
        typescript = {
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
  }

  -- require('lspconfig')['sqls'].setup {
  --   capabilities = capabilities,
  --   on_attach = on_attach,
  -- }

local lspconfig = require("lspconfig")
-- local util = require "lspconfig/util"

  require('lspconfig')['gopls'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {"gopls"},
    filetypes = {"go", "gomod", "gowork", "gotmpl"},
    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
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
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
        semanticTokens = true,
      }
    }
  }





