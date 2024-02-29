-- init.lua

-- empty setup using defaults: add your own options
--require'nvim-tree'.setup {
--}

-- OR


--https://github.com/rafamadriz/friendly-snippets/tree/main/snippets
--require("luasnip.loaders.from_vscode").load() -- Load only python snippets
--require("luasnip/loaders/from_vscode").load({paths = "~/.config/nvim/snippets"})
--



require("luasnip/loaders/from_vscode").lazy_load()
-- require("luasnip").filetype_extend("python", {"django"})
-- require("luasnip").filetype_extend("python", {"django-rest"})
-- require("luasnip").filetype_extend("javascript", {"javascriptreact"})




-- The directories will have to be structured like eg. <https://github.com/rafamadriz/friendly-snippets> (include
-- a similar `package.json`)
--


-- local rt = require("rust-tools")

-- rt.setup({
--   server = {
--     on_attach = function(_, bufnr)
--       -- Hover actions
--       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
--       -- Code action groups
--       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
--     end,
--   },
-- })





-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- local on_attach = function(client)
--     require'completion'.on_attach(client)
-- end
--

lspconfig.rust_analyzer.setup({
 -- on_attach=on_attach,
 settings = {
     ["rust-analyzer"] = {
         imports = {
             granularity = {
                 group = "module",
             },
             prefix = "self",
         },
         cargo = {
             buildScripts = {
                 enable = true,
             },
         },
         procMacro = {
             enable = true
         },
     }
 }
})

--



-- local opts = {
--     tools = { -- rust-tools options
--         autoSetHints = true,
--         inlay_hints = {
--             show_parameter_hints = false,
--             parameter_hints_prefix = "",
--             other_hints_prefix = "",
--         },
--     },

--     -- all the opts to send to nvim-lspconfig
--     -- these override the defaults set by rust-tools.nvim
--     -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
--     server = {
--         -- on_attach is a callback called when the language server attachs to the buffer
--         -- on_attach = on_attach,
--         settings = {
--             -- to enable rust-analyzer settings visit:
--             -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
--             ["rust-analyzer"] = {
--                 -- enable clippy on save
--                 checkOnSave = {
--                     command = "clippy"
--                 },
--             }
--         }
--     },
-- }
-- require('rust-tools').setup(opts)




require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- setup must be called before loading
-- vim.cmd.colorscheme "catppuccin"



require('rose-pine').setup({
	--- @usage 'auto'|'main'|'moon'|'dawn'
	variant = 'auto',
	--- @usage 'main'|'moon'|'dawn'
	dark_variant = 'main',
	bold_vert_split = false,
	dim_nc_background = false,
	disable_background = false,
	disable_float_background = false,
	disable_italics = false,

	--- @usage string hex value or named color from rosepinetheme.com/palette
	groups = {
		background = 'base',
		background_nc = '_experimental_nc',
		panel = 'surface',
		panel_nc = 'base',
		border = 'highlight_med',
		comment = 'muted',
		link = 'iris',
		punctuation = 'subtle',

		error = 'love',
		hint = 'iris',
		info = 'foam',
		warn = 'gold',

		headings = {
			h1 = 'iris',
			h2 = 'foam',
			h3 = 'rose',
			h4 = 'gold',
			h5 = 'pine',
			h6 = 'foam',
		}
		-- or set all headings at once
		-- headings = 'subtle'
	},

	-- Change specific vim highlight groups
	-- https://github.com/rose-pine/neovim/wiki/Recipes
	highlight_groups = {
		ColorColumn = { bg = 'rose' },

		-- Blend colours against the "base" background
		CursorLine = { bg = 'foam', blend = 10 },
		StatusLine = { fg = 'love', bg = 'love', blend = 10 },
	}
})

-- Set colorscheme after options
vim.cmd('colorscheme rose-pine')



-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {'jedi_language_server','tsserver','gopls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end





-- luasnip setup
local luasnip = require 'luasnip'
-- luasnip.filetype_extend("python",{"django"})
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


require("bufferline").setup{

    options = {
        offsets = {{filetype = "NvimTree", text = "Nvim Tree", padding = 1,text_align="center"}},

--     highlights = {
--         fill = {
--             guibg = {
--                 attribute = "fg",
--                 highlight = "Pmenu"
--             }
--         }
--     },
        color_icons=true,

--left_mouse_command = "buffer %d",
--close_command = "bdelete! %d",
--right_mouse_command = "vertical sbuffer %d",
        show_buffer_icons=true,

        numbers="ordinal",

        diagnostics_update_in_insert = false,

        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return "("..count..")"
        end,

        -- show_buffer_close_icons=true,
        show_buffer_default_icon=true,
        show_tab_indicators=true,
        separator_style="thick",



    }

}


-- setup with all defaults
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
-- nested options are documented by accessing them with `.` (eg: `:help nvim-tree.view.mappings.list`).
require'nvim-tree'.setup { -- BEGIN_DEFAULT_OPTS
  auto_reload_on_write = true,
  create_in_closed_folder = false,
  disable_netrw = false,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  ignore_buffer_on_setup = false,
  open_on_setup = false,
  open_on_setup_file = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = true,
  reload_on_bufenter = false,
  respect_buf_cwd = false,
  view = {
    width = 30,
    -- height = 30,
    hide_root_folder = true,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = true,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
        -- user mappings go here
      },
    },
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = true,
    highlight_opened_files = "all",
    root_folder_modifier = ":~",
    indent_markers = {
      enable =true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  ignore_ft_on_setup = {},
  system_open = {
    cmd = "",
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
    },
  },
} -- END_DEFAULT_OPTS


require('lualine').setup {
  options = {
    icons_enabled = true,
    -- theme = 'iceberg_dark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}


--local signature_config = {
  --log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
  --debug = false,
  --hint_enable = false,
  --handler_opts = { border = "single" },
  --max_width = 80,
 --toggle_key = "<C-s>",

--floating_window_off_x = 15, -- adjust float windows x position.
--floating_window_off_y = 15, -- adjust float windows y position.

--}

--require("lsp_signature").setup(signature_config)
--
--
--
--

vim.g.loaded_matchparen = 1 -- disable built-in MatchParen.

--
--


-- NVIM LSP CONFIG
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  --
  --
  --
  --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end





-----------RANDOM CONFIG FROM THE INTERWEBZ---------------


--vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- vim.opt.completeopt = {'menu', 'menuone', 'noselect' }




--require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
--local luasnip = require('luasnip')

local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({

preselect = cmp.PreselectMode.None,
preselect = false,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },

--cmdline(':', {
  --sources = {
    --{ name = 'cmdline' }
  --}
--}),
  sources = {
    {name = 'nvim_lsp', keyword_length = 2},
    {name = 'buffer', keyword_length = 2},
    { name = 'path' , keyword_length = 2},
    {name = 'luasnip', keyword_length = 2},
    {name = 'nvim_lsp_signature_help'}
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = 'Δ',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select =false}),

    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
})


cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })


 --nvim-cmp setup

 --local cmp = require 'cmp'
--cmp.setup {

  --snippet = {
    --expand = function(args)
      --luasnip.lsp_expand(args.body)
    --end,
  --},

    --completion = {
         --completeopt = 'menu,menuone,noinsert',
         --autocomplete = false
      --},
--window = {
  --documentation = cmp.config.window.bordered()
--},

    --formatting = {
  --fields = {'menu', 'abbr', 'kind'}
--},

  --mapping = cmp.mapping.preset.insert({
    --['<C-d>'] = cmp.mapping.scroll_docs(-4),
    --['<C-f>'] = cmp.mapping.scroll_docs(4),
    --['<C-Space>'] = cmp.mapping.complete(),
    --['<CR>'] = cmp.mapping.confirm {
      --behavior = cmp.ConfirmBehavior.Replace,
      --select = true,
    --},
    --['<Tab>'] = cmp.mapping(function(fallback)
      --if cmp.visible() then
        --cmp.select_next_item()
      --elseif luasnip.expand_or_jumpable() then
        --luasnip.expand_or_jump()
    --elseif has_words_before() then
        --cmp.complete()
      --else
        --fallback()
      --end

    --end, { 'i', 's' }),
    --['<S-Tab>'] = cmp.mapping(function(fallback)
      --if cmp.visible() then
        --cmp.select_prev_item()
      --elseif luasnip.jumpable(-1) then
        --luasnip.jump(-1)
      --else
        --fallback()
      --end
    --end, { 'i', 's' }),
  --}),
  --sources = {
        --{ name = "nvim_lsp" },
      --{ name = "treesitter" },
      --{ name = "buffer" },
      --{ name = "luasnip" },
      --{ name = "nvim_lua" },
      --{ name = "path" },
      --{ name = "nvim_lsp_signature_help" },
--}
--}












-- diff view settings oh god

-- Lua
-- local actions = require("diffview.actions")

--require("diffview").setup({
--  diff_binaries = false,    -- Show diffs for binaries
--  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
--  use_icons = true,         -- Requires nvim-web-devicons
--  icons = {                 -- Only applies when use_icons is true.
--    folder_closed = "",
--    folder_open = "",
--  },
--  signs = {
--    fold_closed = "",
--    fold_open = "",
--  },
--  file_panel = {
--    listing_style = "tree",             -- One of 'list' or 'tree'
--    tree_options = {                    -- Only applies when listing_style is 'tree'
--      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
--      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
--    },
--    win_config = {                      -- See ':h diffview-config-win_config'
--      position = "left",
--      width = 35,
--    },
--  },
--  file_history_panel = {
--    --log_options = {
--      --max_count = 256,      -- Limit the number of commits
--      --follow = false,       -- Follow renames (only for single file)
--      --all = false,          -- Include all refs under 'refs/' including HEAD
--      --merges = false,       -- List only merge commits
--      --no_merges = false,    -- List no merge commits
--      --reverse = false,      -- List commits in reverse order
--    --},
--    win_config = {          -- See ':h diffview-config-win_config'
--      position = "bottom",
--      height = 16,
--    },
--  },
--  commit_log_panel = {
--    win_config = {},  -- See ':h diffview-config-win_config'
--  },
--  default_args = {    -- Default args prepended to the arg-list for the listed commands
--    DiffviewOpen = {},
--    --DiffviewFileHistory = {},
--  },
--  hooks = {},         -- See ':h diffview-config-hooks'
--  keymaps = {
--    disable_defaults = false, -- Disable the default keymaps
--    view = {
--      -- The `view` bindings are active in the diff buffers, only when the current
--      -- tabpage is a Diffview.
--      ["<tab>"]      = actions.select_next_entry, -- Open the diff for the next file
--      ["<s-tab>"]    = actions.select_prev_entry, -- Open the diff for the previous file
--      ["gf"]         = actions.goto_file,         -- Open the file in a new split in previous tabpage
--      ["<C-w><C-f>"] = actions.goto_file_split,   -- Open the file in a new split
--      ["<C-w>gf"]    = actions.goto_file_tab,     -- Open the file in a new tabpage
--      ["<leader>e"]  = actions.focus_files,       -- Bring focus to the files panel
--      ["<leader>b"]  = actions.toggle_files,      -- Toggle the files panel.
--    },
--    file_panel = {
--      ["j"]             = actions.next_entry,         -- Bring the cursor to the next file entry
--      ["<down>"]        = actions.next_entry,
--      ["k"]             = actions.prev_entry,         -- Bring the cursor to the previous file entry.
--      ["<up>"]          = actions.prev_entry,
--      ["<cr>"]          = actions.select_entry,       -- Open the diff for the selected entry.
--      ["o"]             = actions.select_entry,
--      ["<2-LeftMouse>"] = actions.select_entry,
--      ["-"]             = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
--      ["S"]             = actions.stage_all,          -- Stage all entries.
--      ["U"]             = actions.unstage_all,        -- Unstage all entries.
--      ["X"]             = actions.restore_entry,      -- Restore entry to the state on the left side.
--      ["R"]             = actions.refresh_files,      -- Update stats and entries in the file list.
--      ["L"]             = actions.open_commit_log,    -- Open the commit log panel.
--      ["<c-b>"]         = actions.scroll_view(-0.25), -- Scroll the view up
--      ["<c-f>"]         = actions.scroll_view(0.25),  -- Scroll the view down
--      ["<tab>"]         = actions.select_next_entry,
--      ["<s-tab>"]       = actions.select_prev_entry,
--      ["gf"]            = actions.goto_file,
--      ["<C-w><C-f>"]    = actions.goto_file_split,
--      ["<C-w>gf"]       = actions.goto_file_tab,
--      ["i"]             = actions.listing_style,        -- Toggle between 'list' and 'tree' views
--      ["f"]             = actions.toggle_flatten_dirs,  -- Flatten empty subdirectories in tree listing style.
--      ["<leader>e"]     = actions.focus_files,
--      ["<leader>b"]     = actions.toggle_files,
--    },
--    file_history_panel = {
--      ["g!"]            = actions.options,          -- Open the option panel
--      ["<C-A-d>"]       = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
--      ["y"]             = actions.copy_hash,        -- Copy the commit hash of the entry under the cursor
--      ["L"]             = actions.open_commit_log,
--      ["zR"]            = actions.open_all_folds,
--      ["zM"]            = actions.close_all_folds,
--      ["j"]             = actions.next_entry,
--      ["<down>"]        = actions.next_entry,
--      ["k"]             = actions.prev_entry,
--      ["<up>"]          = actions.prev_entry,
--      ["<cr>"]          = actions.select_entry,
--      ["o"]             = actions.select_entry,
--      ["<2-LeftMouse>"] = actions.select_entry,
--      ["<c-b>"]         = actions.scroll_view(-0.25),
--      ["<c-f>"]         = actions.scroll_view(0.25),
--      ["<tab>"]         = actions.select_next_entry,
--      ["<s-tab>"]       = actions.select_prev_entry,
--      ["gf"]            = actions.goto_file,
--      ["<C-w><C-f>"]    = actions.goto_file_split,
--      ["<C-w>gf"]       = actions.goto_file_tab,
--      ["<leader>e"]     = actions.focus_files,
--      ["<leader>b"]     = actions.toggle_files,
--    },
--    option_panel = {
--      ["<tab>"] = actions.select_entry,
--      ["q"]     = actions.close,
--    },
--  },
--})
