" Maciej's Vim setup

" basics
set nocompatible
filetype plugin on
syntax on

" settings
set hidden
set history=999
set laststatus=2
set number
set ruler
set shiftwidth=4
set showcmd
set viminfo='100,<50,s10,h,%
set wildmenu
set wildmode=list:longest,full

" bindings
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

let g:ctrlp_cmd = 'CtrlPBuffer'

runtime macros/matchit.vim

" vimwiki setup
let g:vimwiki_list = [{'path': '~/Google Drive/vim/wiki/'}]

colorscheme molokai
