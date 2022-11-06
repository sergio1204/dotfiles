" Gvim font
set guifont=JetBrains\ Mono\ 10
" Syntax highlighting -----------------
syntax on
" Filetype plugins --------------------
filetype plugin on
filetype indent on
" Mouse and number --------------------
set mouse=a
set number
" Vim theme ---------------------------
colorscheme molokai
" Highlighting and smart search -------
set hlsearch
set incsearch
set ignorecase
set smartcase
" Tabs and Spaces ---------------------
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
" Change cursor between mods ----------
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" AirLine -----------------------------
let g:airline_theme='murmur' 
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>0 <Plug>AirlineSelectTab0
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab
" NerdTree ----------------------------
autocmd VimEnter * NERDTree
let NERDTreeShowHidden=1
let NERDTreeShowBookmarks=1
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
" Vim Plug ----------------------------
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
call plug#end()

