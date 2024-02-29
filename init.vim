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
set nowrap
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
" set completeopt=menu,menuone,noselect,noinsert
set termguicolors

" https://github.com/neovim/neovim/issues/21686

call plug#begin()

" UI
Plug 'nvim-lualine/lualine.nvim'
Plug 'RRethy/vim-illuminate'
Plug 'preservim/nerdtree'

" QOL
Plug 'windwp/nvim-autopairs'

" Navigation and leaping
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2'}

" Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
" Plug 'petertriho/cmp-git'

" Commenting
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

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
 
" Rust specific
" Plug 'simrat39/rust-tools.nvim'
Plug 'mrcjkb/rustaceanvim', { 'for': 'rust'}
Plug 'rust-lang/rust.vim', { 'for': 'rust'}
Plug 'saecki/crates.nvim', { 'tag': 'stable' }


" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Themes
Plug 'rose-pine/neovim'
Plug 'nvim-tree/nvim-web-devicons'

" Mason LSP Stuff
Plug 'williamboman/mason.nvim'    
Plug 'williamboman/mason-lspconfig.nvim'

" Snippets
Plug 'rafamadriz/friendly-snippets'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Errors / Debugging 
Plug 'folke/trouble.nvim'
Plug 'mfussenegger/nvim-dap'


call plug#end()

lua require('jacobmaizel')

colorscheme rose-pine


" EXTRA CONFIG, IM TOO LAZY TO MAKE THIS INTO LUA
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let g:Illuminate_ftblacklist = ['nerdtree']
let g:Illuminate_highlightUnderCursor = 1


let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Go syntax highlighting

 " Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_auto_type_info = 1

" Status line types/signatures
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_fmt_command = "goimports"

hi illuminatedWord guibg=#2c313c
" hi link illuminatedWord Visual

" augroup illuminate_augroup
"     autocmd!
"     autocmd VimEnter * hi link illuminatedWord CursorLine
" augroup END