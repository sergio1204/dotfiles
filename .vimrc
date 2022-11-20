" gvim font ==========================
set guifont=Terminus\ 12

" clipboard setting ==================
set clipboard=unnamedplus

" syntax highlighting 
syntax on

" filetype plugins ===================
filetype plugin on
filetype indent on

" mouse and number 
set mouse=a
set number

" vim colorscheme ====================
colorscheme onedark
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" highlighting and smart search ======
set hlsearch
set incsearch
set ignorecase
set smartcase

" tabs and Spaces ====================
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent

" change cursor between mods =========
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" airLine ============================
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_powerline_fonts = 1
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

" nerdTree ===========================
autocmd VimEnter * NERDTree
let NERDTreeShowHidden=1
let NERDTreeShowBookmarks=1
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" vim plug ===========================
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
call plug#end()

