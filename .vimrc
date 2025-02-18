let mapleader = " "
let maplocalleader = " "
inoremap jj <Esc>
" Centered navigation with Ctrl+Up/Down
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround
set showcmd
set autoread
set autowrite
set conceallevel=1
set relativenumber
nnoremap <leader>y "+y
vnoremap <leader>y "+y

" Fix key repeat behavior to match Neovim
set ttimeoutlen=0
set ttyfast
set noesckeys
