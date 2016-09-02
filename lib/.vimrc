"*********************************
"       Charlie Customize
"*********************************

"------------VIM Colorscheme------------
colorscheme lucid
"colorscheme slate

"------------VIM Setting------------
filetype plugin indent on
syntax on
set nocompatible
set t_Co=256
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set cursorline 
set cursorcolumn
set showtabline=2
"set mouse=a

"pastetoggle
nnoremap <F10> :set invpaste paste?<CR>
set pastetoggle=<F10>
set showmode

"------------Load pathogen(VIM plugin management)-------------
execute pathogen#infect()

"------------Plugin: vim-indent-guides------------
"let g:indent_guides_guide_size=1

"------------Plugin: nerdtree------------
map <C-n> :NERDTreeToggle<CR>
map <C-l> :tabn<CR>
map <C-k> :tabp<CR>
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"------------Plugin: vim-airline------------
set laststatus=2
let g:airline_theme = 'powerlineish'

" Enable powerline icon
let g:airline_powerline_fonts = 1

" Enable tabline theme
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#show_buffers = 0
"let g:airline#extensions#tabline#tab_nr_type = 1
""let g:airline#extensions#tabline#left_sep = ' '
""let g:airline#extensions#tabline#left_alt_sep = '|'
