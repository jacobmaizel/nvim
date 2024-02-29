filetype plugin indent on
set pumheight=15
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set showmatch      " highlight matching brackets
" set matchparen     " enable matching bracket highlighting
"
syntax on


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



set completeopt=menu,menuone,noselect,noinsert


 " set omnifunc=ale#completion#OmniFunc
  let g:ale_completion_enabled = 0



" random ones that prime was talking about
" set noshowmode
set termguicolors

call plug#begin()
" Colorschemes and stuff
" Plug 'projekt0n/github-nvim-theme'
Plug 'gruvbox-community/gruvbox'
Plug 'crusoexia/vim-dracula'
Plug 'cormacrelf/vim-colors-github'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }


Plug 'davidhalter/jedi-vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'


Plug 'sindrets/diffview.nvim'
"Plug 'ray-x/lsp_signature.nvim'

" Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

Plug 'tpope/vim-surround'
" Plug 'jiangmiao/auto-pairs'

Plug 'mhinz/vim-signify'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-fugitive'
"Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-commentary'
Plug 'moll/vim-bbye'
Plug 'akinsho/bufferline.nvim'

Plug 'nvim-lua/plenary.nvim'

Plug 'ThePrimeagen/harpoon'
Plug 'nvim-telescope/telescope.nvim'
Plug 'mbbill/undotree'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'






" Rust
" Plug 'simrat39/rust-tools.nvim'

Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'




Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }


" CMP Plugins
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

Plug 'dense-analysis/ale'

" snippets
Plug 'rafamadriz/friendly-snippets'
Plug 'L3MON4D3/LuaSnip'
Plug 'majutsushi/tagbar'
Plug 'lilydjwg/colorizer'
Plug 't9md/vim-choosewin'
Plug 'rose-pine/neovim'

"Plug 'ryanoasis/vim-devicons'
call plug#end()

lua require('init')



let mapleader = " "


"if exists("g:loaded_webdevicons")
"call webdevicons#refresh()
"endif

" set the python virtual env.. also could check with :checkhealth
" let g:python3_host_prog = "path-to-interpreter"
" https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments



" Telescope mappings
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({search = vim.fn.input("Grep For > ")})<cr>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

 " Map keys for most used commands.
 " Ex: `\b` for building, `\r` for running and `\b` for running test.
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)


"nnoremap <leader>d :DiffViewOpen<CR>

 let g:AutoPairsShortcutToggle = ''



let g:jedi#show_call_signatures = "0"
"
"let g:nvim_tree_indent_markers=1
"


" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

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




let g:doge_enable_mappings=1
let g:doge_python_settings = {
\  'single_quotes': 0
\}

let g:NERDTreeWinPos = "left"


"let g:ale_fixers = {
    "\    '*': ['remove_trailing_lines', 'trim_whitespace'],
    "\    'javascript': ['eslint', 'prettier'],
    "\    'python': ['black','isort']
    "\}
"let g:ale_fix_on_save = 1




nnoremap <C-h> :ALEHover<CR>


" Error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'


let g:ale_python_auto_pipenv=0
" let g:ale_python_auto_pipenv_maxdepth = 10

let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1


" let g:ale_sign_column_always = 1




let g:ale_fixers = {}
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_fixers['hcl'] = ['terraform']
let g:ale_fixers['html'] = ['prettier']
let g:ale_fixers['javascript'] = ['eslint','prettier']
let g:ale_fixers['json'] = ['jq']
let g:ale_fixers['python'] = ['black','isort']
" let g:ale_fixers['python'] = ['black']
let g:ale_fixers['go'] = ['gofmt','goimports']
let g:ale_fixers['rust'] = ['rustfmt']
let g:ale_fixers['scss'] = ['prettier']
let g:ale_fixers['sh'] = ['shfmt']
let g:ale_fixers['terraform'] = ['terraform']
let g:ale_fixers['typescript'] = ['prettier']

let g:ale_javascript_prettier_options = '--tab-width 2 --print-width 120 --single-quote'
let g:ale_json_jq_options = '-S'


let g:ale_linters = {'rust': ['analyzer','rls','cargo'],'go':['gopls','gofmt']}

"

 " let g:ale_linters = {'rust': ['rls','cargo'],'go':['gopls','gofmt']}



" let g:ale_python_black_options = '--line-length 70'
"let g:ale_python_pylint_options = '--max-line-length 120'
"88 Tree stuff
"

" let g:ale_python_black_change_directory = 0

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>


" Bufferline
" These commands will navigate through buffers in order regardless of which mode you are using
" e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
"nnoremap <silent>[b :BufferLineCycleNext<CR>
"nnoremap <silent>b] :BufferLineCyclePrev<CR>

nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
nnoremap <silent><leader>6 <Cmd>BufferLineGoToBuffer 6<CR>
nnoremap <silent><leader>7 <Cmd>BufferLineGoToBuffer 7<CR>
nnoremap <silent><leader>8 <Cmd>BufferLineGoToBuffer 8<CR>
nnoremap <silent><leader>9 <Cmd>BufferLineGoToBuffer 9<CR>

" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap <silent>]q :BufferLineCycleNext<CR>
nnoremap <silent>[q :BufferLineCyclePrev<CR>

" These commands will sort buffers by directory, language, or a custom criteria
"nnoremap <silent>be :BufferLineSortByExtension<CR>
"nnoremap <silent>bd :BufferLineSortByDirectory<CR>
"nnoremap <silent><mymap> :lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>


" Colorscheme settings
" let g:gruvbox_contrast_dark= 'hard'
" colorscheme dracula

" colorscheme
"
" colorscheme github_dark
" colorscheme github
"
" hi Normal ctermbg=none guibg=none


-
" Tagbar -----------------------------
" toggle tagbar display
map <F4> :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 1
let g:Tlist_Ctags_Cmd='/opt/homebrew/Cellar/ctags/5.8_2/bin/ctags'

" Autorefresh on tree focus
function! NERDTreeRefresh()
    if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
endfunction

autocmd BufEnter * call NERDTreeRefresh()




" Window Chooser ------------------------------
" mapping
nmap  -  <Plug>(choosewin)
" show big letters
"let g:choosewin_overlay_enable = 1



" highlight NvimTreeFolderIcon guibg=black






" function! TrimWhitespace()
"   let l:save = winsaveview()
"   keeppatterns %s/\s\+$//e
"   call winrestview(l:save)
" endfunction

" augroup trim_spaces
"   autocmd!
"   autocmd BufWritePre * :call TrimWhitespace()
" augroup END

lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"python","rust","go","javascript","html","lua","vim","css",
    "tsx","toml","json","bash","regex","comment","markdown","typescript"},


    highlight = {
    enable = true,
  },
}
EOF
