-- Other rust stuff
require('crates').setup()

local on_attach = function(client, bufnr)
    -- you can also put keymaps in here
 
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

    -- vim.lsp.inlay_hint.enable(bufnr, true)

    vim.opt.updatetime = 250

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

local lspconfig = require("lspconfig")
-- local util = require "lspconfig/util"


vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
        runnables = {
          use_telescope = true,
        },
        inlay_hints = {
          auto = true,
          show_parameter_hints = true,
          parameter_hints_prefix = "",
          other_hints_prefix = "",
        },
    },
    -- LSP configuration
    -- float_win_config = {

    -- auto_focus = true,
    -- },
    server = {
      on_attach = on_attach,
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    --   root_dir = util.root_pattern("Cargo.toml"),
      default_settings = {
        -- rust-analyzer language server configuration
        ['rust-analyzer'] = {
            checkOnSave = {
                command = "clippy",
              },
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true
            },
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
        },
      },
    },
    -- DAP configuration
    -- dap = {
    -- },
  }
