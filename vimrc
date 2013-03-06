" Maciej's Vim setup

" Vundle setup {{{1
set nocompatible               " be iMproved

" Ultimately want filetype off for Vundle here, but this on-then-off hack is
" to fix an annoying issue:
"   http://tooky.co.uk/2010/04/08/there-was-a-problem-with-the-editor-vi-git-on-mac-os-x.html
filetype on
filetype off                   " required!

if has ("win32")
    set runtimepath+=$HOME/vimfiles/bundle/vundle/
else
    set runtimepath+=$HOME/.vim/bundle/vundle/
endif
call vundle#rc()

" let Vundle manage Vundle
Bundle "gmarik/vundle"

" Bundles {{{1
"
Bundle "matchit.zip"
Bundle "bufexplorer.zip"
Bundle "scrooloose/nerdcommenter"
Bundle "scrooloose/nerdtree"
Bundle "vimwiki"
Bundle "kien/ctrlp.vim"
Bundle "kien/rainbow_parentheses.vim"
Bundle "kien/tabman.vim"

" color themes
Bundle "nanotech/jellybeans.vim"
Bundle "tomasr/molokai"
"Bundle "flazz/vim-colorschemes"

" learn more about these
Bundle "tpope/vim-fugitive"
Bundle "tpope/vim-surround"
Bundle "thinca/vim-fontzoom"

" to try
"Bundle "techlivezheng/vim-plugin-minibufexpl"
"Bundle "snipMate"
"Bundle "h1mesuke/unite-outline"
"Bundle "jnwhiteh/vim-golang"
"Bundle "Lokaltog/vim-powerline"

" Org mode in Vim
"https://github.com/hsitz/VimOrganizer
"Bundle "jceb/vim-orgmode"

filetype plugin indent on     " required!
" or
" filetype plugin on          " to not use the indentation settings set by plugins

" basics {{{1
syntax enable

" settings {{{1
set diffopt+=vertical
set expandtab
set foldlevelstart=3
set hidden
set history=999
set laststatus=2
set list
set listchars=tab:»·,trail:·,extends:»,precedes:«
set matchpairs+=<:>
set modeline
set number
set ruler
set scrolloff=3
set shiftwidth=4
set showcmd
set showmode
set viminfo='100,<50,s10,h,%
set wildmenu
set wildmode=list:longest,full

" search settings {{{1
set ignorecase
set infercase
set smartcase
set nowrapscan
set hlsearch
set incsearch
" hit C-l to run :noh AND redraw screen (from "Pratical Vim")
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" soft breaks {{{1
set textwidth=78
set formatoptions=tcqn

set nowrap
" uncomment for wrapping; might need to turn off 'list'
"set wrap
"set wrapmargin=2
"set showbreak=…
"set linebreak

" bindings {{{1
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Rainbow Parentheses {{{1
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" miscellaneous {{{1
let g:ctrlp_cmd = 'CtrlPBuffer'

runtime macros/matchit.vim

" vimwiki setup
let g:vimwiki_list = [{'path': '~/Google Drive/vim/wiki/'}]
let g:vimwiki_folding = 1

colorscheme molokai

command! W :w  " in case we didn't let go of Shift fast enough

" This is at least where the words are on OS X.
set dictionary=/usr/share/dict/words

" Apply any local settings. {{{1
if has('win32') || has('win64') || has('win16')
    let local_settings = $HOME . "vimfiles/LOCAL/local.vim"
else
    let local_settings = $HOME . "/.vim/LOCAL/local.vim"
endif

if filereadable(local_settings)
    exec ":source " . local_settings
endif

" }}}1
" vim:fdm=marker:
