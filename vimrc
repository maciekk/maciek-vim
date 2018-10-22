" Maciej's Vim setup
"
" Version controlled here:
"   https://github.com/maciekk/vimrc

" Vundle setup {{{1
set nocompatible               " be iMproved

" Ultimately want "filetype off" for Vundle here, but this on-then-off hack is
" to fix an annoying issue:
"   http://tooky.co.uk/2010/04/08/there-was-a-problem-with-the-editor-vi-git-on-mac-os-x.html
filetype on
filetype off                   " required!

if has ('win32')
    let $MYVIMDIR="~/vimfiles"
else
    let $MYVIMDIR="~/.vim"
endif
set runtimepath+=$MYVIMDIR

let &runtimepath.=','.$MYVIMDIR.'/bundle/Vundle.vim'
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/vundle'

" bundles {{{1
"
" Main bindings to remember/use:
" - \be : BufferExplorer
" - <C-p> : CtrlP
" - \mt | \mf : Tabman
" - :Note : note taking
Plugin 'Lokaltog/vim-powerline'
Plugin 'bufexplorer.zip'
Plugin 'kien/ctrlp.vim'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'kien/tabman.vim'
Plugin 'matchit.zip'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'sjl/gundo.vim'
"Plugin 'TVO--The-Vim-Outliner'
Plugin 'utl.vim'
"Plugin 'VimOutliner'
Plugin 'insanum/votl'
Plugin 'vimwiki'
Plugin 'chrisbra/NrrwRgn'
Plugin 'freitass/todo.txt-vim'

" snippets
"Plugin 'SirVer/ultisnips'
Plugin 'acustodioo/vim-snippets'

" outline stuff; dump?
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neocomplcache'
Plugin 'h1mesuke/unite-outline'

" HTML
Plugin 'mattn/emmet-vim'

" learn more about these
Plugin 'vim-scripts/VOoM'
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'fatih/vim-go'
Plugin 'majutsushi/tagbar'
Plugin 'thinca/vim-fontzoom'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'

" suggested by YouCompleteMe (corp)
Plugin 'scrooloose/syntastic'

" Markdown improvements
"Plugin 'godlygeek/tabular'
"Plugin 'plasticboy/vim-markdown'
Plugin 'vim-pandoc/vim-pandoc-syntax'

" to try
"Plugin 'xolox/vim-session'
"Plugin 'techlivezheng/vim-plugin-minibufexpl'
"Plugin 'taglist.vim'  " superseded by 'tagbar'?

" Org mode in Vim
"https://github.com/hsitz/VimOrganizer
"Plugin 'jceb/vim-orgmode'

" color themes
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'
"Plugin 'flazz/vim-colorschemes'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" or
" filetype plugin on          " to not use the indentation settings set by plugins

" settings {{{1
set backspace=indent,eol,start
set cmdheight=1
set diffopt+=vertical
set directory=~/tmp,/var/tmp/,/tmp,.
set expandtab
set foldlevelstart=0
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
set backupdir=~/bak,~/tmp,.,/tmp

" mappings {{{1
command! W :w  " in case we didn't let go of Shift fast enough
map <C-s> :w<CR>
imap <C-s> <C-o>:w<CR>

" Swap keys for filtered/unfiltered history scroll.
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>

map ,fb :FufBuffer<CR>
map ,fd :FufDir<CR>
map ,ff :FufFile<CR>

" Mapping to repeat last search using global command, and bring up quickfix.
" Purloined from:
"   http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/
nmap g/ :vimgrep /<C-R>//j %<CR>\|:cw<CR>

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

"" TODO: Temporary
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

" Vimwiki {{{2
" NOTE: set / override g:vimwiki_list in local.vim
let g:vimwiki_list = [{'path': '~/Google Drive/vim/wiki/'}]
let g:vimwiki_folding = 'expr'

" Powerline {{{2
let g:Powerline_symbols = 'compatible'

" CtrlP {{{2
let g:ctrlp_cmd = 'CtrlPBuffer'

" Notes {{{2
:let g:notes_directories = ['~/Google Drive/Notes']

" NarrowRegion {{{2
let g:nrrw_rgn_rel_min = 10
let g:nrrw_rgn_rel_max = 80
let g:nrrw_rgn_incr = 99

" pandoc-syntax {{{2
" This is needed only if don't also have `pandoc` package installed.
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END

let g:pandoc#syntax#conceal#use=1
let g:pandoc#syntax#conceal#urls=1
let g:pandoc#syntax#style#emphases=1
let g:pandoc#syntax#style#underline_special=1

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
"colorscheme fine_blue
syntax enable

" misc {{{1

source $MYVIMDIR/abbreviations.vim

" TODO: is this needed?
runtime macros/matchit.vim

" One is bound to use the LocalLeader more often (it is specific to the
" buffer/file), so it should use the easier-to-reach character.
let mapleader = "\\"
let maplocalleader = ","

" Esc alternative (easy on Dvorak)
inoremap hh <Esc>

" todo.txt additional bindings
augroup todotxtgroup
    autocmd!
    autocmd BufNewFile,BufRead,BufEnter todo.txt so $MYVIMDIR/todo-extra.vim
augroup END

" Quick edit & similar
nnoremap <Leader>ev :vsplit ~/.vim/vimrc<cr>
nnoremap <Leader>sv :source $MYVIMRC<cr>
nnoremap <Leader>g :e ~/Google\ Drive/GTD/gtd.txt<cr>
nnoremap <Leader>es :vsplit ~/secure/scratch.txt<cr>

" other
autocmd Filetype gtd setlocal fdm=indent

hi ColorColumn guibg=#330000 ctermbg=Black

" Stolen from:
"   https://youtu.be/aHm36-na4-4?list=PLdyMeP7HZ2xYPEilzjwqK6LDKOrGFtowI
"   (4:04 timepoint)
"set nocolorcolumn
"call matchadd('ColorColumn', '\%81v', 100)

" From:
"  http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Do not reveal Conceals items if in normal mode.
set cocu=n

" }}}1
" vim:fdm=marker:
