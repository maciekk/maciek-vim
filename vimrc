" Maciej's Vim setup

" basics
set nocompatible
filetype plugin on
syntax enable

" settings
set backspace=indent,eol,start
set cmdheight=1
set diffopt+=vertical
set directory=~/tmp,/var/tmp/,/tmp
set expandtab
set hidden
set history=999
set laststatus=2
set matchpairs+=<:>
set modeline
set number
set ruler
set scrolloff=3
set shiftwidth=4
set showcmd
set showmatch
set showmode
set viminfo='100,<50,s10,h,%
set wildmenu
set wildmode=list:longest,full

" search settings
set ignorecase
set smartcase
set nowrapscan
set hlsearch
set incsearch
" hit C-l to run :noh AND redraw screen (from "Pratical Vim")
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" soft breaks
set textwidth=78
set formatoptions=tcqn

" uncomment for wrapping; might need to turn off 'list'
"set wrap
"set wrapmargin=2
"set showbreak=…
"set linebreak

set list
"set listchars=tab:\ \ ,trail:\ ,extends:»,precedes:«
set listchars=tab:»·,trail:·,extends:»,precedes:«

" bindings
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

let g:ctrlp_cmd = 'CtrlPBuffer'

runtime macros/matchit.vim

" vimwiki setup
let g:vimwiki_list = [{'path': '~/Google Drive/vim/wiki/'}]

colorscheme molokai

command! W :w  " in case we didn't let go of Shift fast enough

" Apply any local settings.
if has('win32') || has('win64') || has('win16')
    let local_settings = $HOME . "vimfiles/LOCAL/local.vim"
else
    let local_settings = $HOME . "/.vim/LOCAL/local.vim"
endif

if filereadable(local_settings)
    exec ":source " . local_settings
endif

