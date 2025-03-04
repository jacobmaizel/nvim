set pumheight=15
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set showmatch 
set nu
set relativenumber
set hidden
set nohlsearch
set noerrorbells
" set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set colorcolumn=90
set signcolumn=yes
set background=dark
set completeopt=menuone,noselect,noinsert
set termguicolors

" https://github.com/neovim/neovim/issues/21686
" let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
" if empty(glob(data_dir . '/autoload/plug.vim'))
"   silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif

" if empty(glob('~/.vim/autoload/plug.vim'))
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" endif

" " Run PlugInstall if there are missing plugins
" autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"   \| PlugInstall --sync | source $MYVIMRC
" \| endif


call plug#begin()

" UI
Plug 'nvim-lualine/lualine.nvim'
Plug 'RRethy/vim-illuminate'
" Plug 'preservim/nerdtree'

" QOL
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'ggandor/leap.nvim'
Plug 'tpope/vim-repeat'

" Navigation and leaping
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2'}
Plug 'stevearc/oil.nvim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
" Plug 'petertriho/cmp-git'
Plug 'kdheepak/lazygit.nvim'

" Commenting
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
" Plug 'tomtom/tcomment_vim'
Plug 'preservim/nerdcommenter'
" Plug 'numToStr/Comment.nvim'
" Plug 'suy/vim-context-commentstring'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Syntax Highlighting
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}


" nvim-cmp
Plug 'hrsh7th/nvim-cmp'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'lukas-reineke/cmp-under-comparator'
 
" Rust specific
" Plug 'simrat39/rust-tools.nvim'
Plug 'mrcjkb/rustaceanvim', { 'for': 'rust'}
Plug 'rust-lang/rust.vim', { 'for': 'rust'}
Plug 'saecki/crates.nvim', { 'tag': 'stable' }

" TS JS
" Plug 'prettier/vim-prettier', {
"   \ 'do': 'yarn install --frozen-lockfile --production',
"   \ 'for': ['javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
  " \ 'for': [ 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

" Go
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }


" Mason LSP Stuff
Plug 'williamboman/mason.nvim'    
Plug 'williamboman/mason-lspconfig.nvim'

" Linting
Plug 'mfussenegger/nvim-lint'

" Snippets
Plug 'rafamadriz/friendly-snippets'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Errors / Debugging 
Plug 'folke/trouble.nvim'
" Plug 'mfussenegger/nvim-dap'

" Tmux 
Plug 'christoomey/vim-tmux-navigator'

" Copilot
" Plug 'github/copilot.vim'

" lsp kind
Plug 'onsails/lspkind.nvim'

" Context
Plug 'SmiteshP/nvim-navic'
Plug 'utilyre/barbecue.nvim'

" CMDLine 
" Plug 'folke/noice.nvim'
" Plug 'MunifTanjim/nui.nvim'
" Plug 'rcarriga/nvim-notify'

" Themes
" Plug 'rose-pine/neovim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-tree/nvim-web-devicons'
" Plug 'ryanoasis/vim-devicons'

Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'OXY2DEV/markview.nvim'

Plug 'norcalli/nvim-colorizer.lua'

" formatter managers
Plug 'stevearc/conform.nvim'

call plug#end()


lua require('jacobmaizel')




" EXTRA CONFIG, IM TOO LAZY TO MAKE THIS INTO LUA
" nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
" nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>
" let g:Illuminate_ftblacklist = ['nerdtree']
" let g:Illuminate_highlightUnderCursor = 1

" let g:go_def_mode='gopls'
" let g:go_info_mode='gopls'

" Go syntax highlighting
 " Auto formatting and importing
" let g:go_fmt_autosave = 1
" let g:go_auto_type_info = 0

" Status line types/signatures
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_function_calls = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_types = 1
" let g:go_fmt_command = "goimports"

" Prettier settings
" let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0




" Nerd Tree
" " Exit Vim if NERDTree is the only window remaining in the only tab.
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" " Close the tab if NERDTree is the only window remaining in it.
" autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
" autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
"     \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

"if exists('g:context#commentstring#table')
  "let g:context#commentstring#table['javascript.jsx'] = {
              "\ 'jsComment' : '// %s',
              "\ 'jsImport' : '// %s',
              "\ 'jsxStatment' : '// %s',
              "\ 'jsxRegion' : '{/*%s*/}',
              "\}
"endif
"

let g:NERDCustomDelimiters={
	\ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
\}
