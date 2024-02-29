local on_attach = function(client, bufnr)
    -- you can also put keymaps in here
    print("attached go a buffer, setting keymaps")

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



    -- setup inlay hints

  -- if client.server_capabilities.inlayHintProvider then
  --       vim.lsp.buf.inlay_hint(bufnr, true)
  -- end
  --
    vim.lsp.inlay_hint.enable(bufnr, true)
    -- vim.lsp.inlay_hint.enable(0, true

    vim.opt.updatetime = 299

    -- Show diagnostic popup on cursor hover
    local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
    end,
    group = diag_float_grp,
    })

    -- Goto previous/next diagnostic warning/error
    vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
    vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)


end
  -- Set up nvim-cmp.
  local cmp = require'cmp'
  cmp.setup({
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon ={
                nvim_lsp = 'λ',
                vsnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp', keyword_length = 2 },      -- from language server
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'nvim_lua', keyword_length = 2},

        { name = 'nvim_lsp_signature_help'},
        -- { name = 'cmdline' },
      }, {
      })
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
  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities,
    on_attach = on_attach
  }

local lspconfig = require("lspconfig")
-- local util = require "lspconfig/util"

  require('lspconfig')['gopls'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {"gopls"},
    filetypes = {"go", "gomod", "gowork", "gotmpl"},
    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
    settings = {


         hints = {
           ["parameterNames"] = true,
          ["compositeLiteralFields"] = true,
          ["compositeLiteralTypes"] = true,
          constantValues = true,
          rangeVariableTypes = true,
          functionTypeParameters = true,
          assignVariableTypes = true,
        },
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

