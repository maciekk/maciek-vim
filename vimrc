" Maciej's Vim setup
"
" Version controlled here:
"   https://code.google.com/p/maciek-vim/

" Vundle setup {{{1
set nocompatible               " be iMproved

" Ultimately want "filetype off" for Vundle here, but this on-then-off hack is
" to fix an annoying issue:
"   http://tooky.co.uk/2010/04/08/there-was-a-problem-with-the-editor-vi-git-on-mac-os-x.html
filetype on
filetype off                   " required!

if has ('win32')
    set runtimepath+=$HOME/vimfiles/bundle/vundle/
else
    set runtimepath+=$HOME/.vim/bundle/vundle/
endif
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" bundles {{{1
"
Bundle 'Lokaltog/vim-powerline'
Bundle 'bufexplorer.zip'
Bundle 'kien/ctrlp.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'kien/tabman.vim'
Bundle 'matchit.zip'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'sjl/gundo.vim'
"Bundle 'TVO--The-Vim-Outliner'
Bundle 'utl.vim'
"Bundle 'VimOutliner'
Bundle 'insanum/votl'
Bundle 'vimwiki'
Bundle 'chrisbra/NrrwRgn'

" snippets
Bundle 'SirVer/ultisnips'
Bundle 'acustodioo/vim-snippets'

" outline stuff; dump?
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/neocomplcache'
Bundle 'h1mesuke/unite-outline'

" HTML
Bundle 'mattn/emmet-vim'

" learn more about these
Bundle 'vim-scripts/VOoM'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'jnwhiteh/vim-golang'
Bundle 'majutsushi/tagbar'
Bundle 'thinca/vim-fontzoom'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'

" suggested by YouCompleteMe (corp)
Bundle 'scrooloose/syntastic'

" to try
"Bundle 'xolox/vim-session'
"Bundle 'techlivezheng/vim-plugin-minibufexpl'
"Bundle 'taglist.vim'  " superseded by 'tagbar'?

" Org mode in Vim
"https://github.com/hsitz/VimOrganizer
"Bundle 'jceb/vim-orgmode'

" color themes
Bundle 'nanotech/jellybeans.vim'
Bundle 'tomasr/molokai'
"Bundle 'flazz/vim-colorschemes'

filetype plugin indent on     " required!
" or
" filetype plugin on          " to not use the indentation settings set by plugins

" settings {{{1
set backspace=indent,eol,start
set cmdheight=1
set diffopt+=vertical
set directory=~/tmp,/var/tmp/,/tmp,.
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
set scrolloff=1
set shiftwidth=4
set shortmess+=I
set showcmd
set showmatch
set showmode
set splitbelow
set splitright
set viminfo='100,<50,s10,h,%
set wildmenu
set wildmode=list:longest,full

" This is at least where the words are on OS X.
set dictionary=/usr/share/dict/words

" search settings {{{2
set ignorecase
set infercase
set smartcase
set nowrapscan
set hlsearch
set incsearch
" hit C-l to run :noh AND redraw screen (from "Pratical Vim")
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" soft breaks {{{2
set textwidth=78
set formatoptions=tcqn

set nowrap
" uncomment for wrapping; might need to turn off 'list'
"set wrap
"set wrapmargin=2
"set showbreak=…
"set linebreak

set backup
set backupcopy=yes
set backupdir=~/.bak,~/tmp,.,/tmp

" mappings {{{1
command! W :w  " in case we didn't let go of Shift fast enough

map \bi :source $MYVIMRC<bar>:BundleInstall<CR>
map \bc :BundleClean<CR>
map \bu :BundleUpdate<CR>

map ,,v :VoomToggle vimwiki<CR>

map ,,w :wall<CR>

" collapse all folds except the one where cursor is
map ,zz zMzv
map ,zj zMjzv
map ,zk zMkzv

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

map ,fb :FufBuffer<CR>
map ,fd :FufDir<CR>
map ,ff :FufFile<CR>

" package setup {{{1
" Rainbow Parentheses {{{2
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

" Vimwiki {{{2
" NOTE: set / override g:vimwiki_list in local.vim
let g:vimwiki_list = [{'path': '~/Google Drive/vim/wiki/'}]
let g:vimwiki_folding = 'expr'

" Powerline {{{2
let g:Powerline_symbols = 'compatible'

" CtrlP {{{2
let g:ctrlp_cmd = 'CtrlPBuffer'

" local configs {{{1
if has('win32') || has('win64') || has('win16')
    let local_settings = $HOME . 'vimfiles/LOCAL/local.vim'
else
    let local_settings = $HOME . '/.vim/LOCAL/local.vim'
endif

if filereadable(local_settings)
    exec ':source ' . local_settings
endif

" cosmetics {{{1
colorscheme molokai
"colorscheme pyte
syntax enable

" GTD {{{1
let g:GTD_path = "~/Google Drive/GTD"
if !isdirectory(glob(g:GTD_path))
    let g:GTD_path = "~/GTD"
endif

function! GtdFindSection(section)
    call cursor(1, 1)
    let l:loc = search("^\\S.*" . a:section)
    if l:loc > 0
        call cursor(l:loc, 1)
    endif
endfunction

" Create global mapping to go to "today" daily page.
function! EditTodayDaily()
    let l:daily_fname = g:GTD_path . strftime("/daily/%Y-%m-%d.txt")
    " TODO: this creates unwanted new tab when current instance of buffer is
    " in split window
    execute "tab drop" fnameescape(expand(l:daily_fname))
    call GtdFindSection("now")
endfunction
noremap <Leader>t :call EditTodayDaily()<cr>

" default template
augroup gtdgroup
  autocmd!
  autocmd BufNewFile */GTD/daily/*.txt execute "0r" fnameescape(join([g:GTD_path, "/daily/template.txt"], ""))
augroup END

" misc {{{1

" TODO: is this needed?
runtime macros/matchit.vim

" One is bound to use the LocalLeader more often (it is specific to the
" buffer/file), so it should use the easier-to-reach character.
let mapleader = "\\"
let maplocalleader = ","

" Quick edit of vimrc file
nnoremap <Leader>ev :vsplit $MYVIMRC<cr>
nnoremap <Leader>sv :source $MYVIMRC<cr>

" }}}1
" vim:fdm=marker:
