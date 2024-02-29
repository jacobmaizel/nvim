
filetype plugin indent on
set pumheight=15
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set relativenumber
set hidden
set nohlsearch
set noerrorbells
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch

set scrolloff=8
" set colorcolumn=90
set signcolumn=yes


let mapleader = " "

nnoremap <leader>l $i

call plug#begin()


Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()




" set nu
"
"
" set nowrap
"
""


"lua <<EOF


"EOF
