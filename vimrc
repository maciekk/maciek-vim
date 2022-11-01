" Maciej's Vim setup
"
" Version-controlled here:
"   https://github.com/maciekk/vimrc

" TODO:
" - why upon start is there always an empty buffer, in addition to buffers
"   from last session?
" - check for 'netrw'
" - why does 'vim256-color' colorscheme set fail on Win32?

" Choose better leaders.
let mapleader = " "
let maplocalleader = ","

" First, some mappings to work with this config file.
nnoremap <Leader>ve :vsplit ~/.vim/vimrc<cr>
nnoremap <Leader>vs :so $MYVIMRC<cr>
nnoremap <Leader>vp :so $MYVIMRC<cr>\|:VundleClean<cr>\|:VundleInstall<cr>

" Vundle setup {{{1
set nocompatible               " be iMproved

" Ultimately want "filetype off" for Vundle here, but this on-then-off hack is
" to fix an annoying issue:
"   http://tooky.co.uk/2010/04/08/there-was-a-problem-with-the-editor-vi-git-on-mac-os-x.html
filetype on
filetype off                   " required!

if has ('win32')
    let $MYVIMDIR="~/vimfiles"
    let vundlepath='~/vimfiles/bundle'
else
    let $MYVIMDIR="~/.vim"
    let vundlepath='~/.vim/bundle'
endif
set runtimepath+=$MYVIMDIR

let &runtimepath.=','.$MYVIMDIR.'/bundle/Vundle.vim'
call vundle#begin(vundlepath)

" let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" plugins {{{1

let $PLUGDIR=$MYVIMDIR.'/plugins'

" fancy startup page
"Plugin 'mhinz/vim-startify'

" fundamentals {{{2
so $PLUGDIR/verbs-n-nouns.vim
so $PLUGDIR/undo.vim
so $PLUGDIR/matchit.vim
so $PLUGDIR/narrow.vim

" conveniences {{{2
so $PLUGDIR/ctrlp.vim
"so $PLUGDIR/snippets.vim
Plugin 'romainl/vim-cool'
Plugin 'airblade/vim-rooter'
Plugin 'tpope/vim-obsession'

" tools {{{2
so $PLUGDIR/nerd.vim
so $PLUGDIR/git.vim
so $PLUGDIR/markdown.vim
so $PLUGDIR/wiki.vim
so $PLUGDIR/floaterm.vim
so $PLUGDIR/notes.vim
"so $PLUGDIR/outliners.vim
"so $PLUGDIR/org.vim
Plugin 'bufexplorer.zip'
"Plugin 'mileszs/ack.vim'

" languages {{{2
Plugin 'mattn/emmet-vim'  " HTML
"Plugin 'fatih/vim-go'

" aeshtetics {{{2
"so $PLUGDIR/powerline.vim
so $PLUGDIR/airline.vim
so $PLUGDIR/rainbow.vim
so $PLUGDIR/colorschemes.vim

" hide the vertical bar in vsplit
"hi VertSplit guibg=bg guifg=bg
set fillchars-=vert:\| | set fillchars+=vert:\│
" alt chars: │┃┊┋

" review & try
"Plugin 'FuzzyFinder'
"Plugin 'thinca/vim-fontzoom'
"Plugin 'techlivezheng/vim-plugin-minibufexpl'
"Plugin 'taglist.vim'  " superseded by 'tagbar'?

" suggested by YouCompleteMe (corp)
"Plugin 'scrooloose/syntastic'

" cemetary: no longer used
"Plugin 'kien/tabman.vim'
"Plugin 'freitass/todo.txt-vim'

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
set encoding=utf-8
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
set path=.,**
set relativenumber
set ruler
set scrolloff=4
set sidescrolloff=4
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
set wildoptions=fuzzy,pum

" This is at least where the words are on OS X.
set dictionary=/usr/share/dict/words

" search settings {{{2
set ignorecase
set infercase
set smartcase
set nowrapscan
set hlsearch
set incsearch

" hit C-l to run :noh AND redraw screen (h/t "Pratical Vim")
" disabled: now use vim-cool plugin for it
"nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" soft breaks {{{2
set textwidth=78
set formatoptions=tcq2n
set autoindent

set nowrap
" uncomment for wrapping; might need to turn off 'list'
"set wrap
"set wrapmargin=2
"set showbreak=â¦
"set linebreak

" backup {{{2
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

" Close all /other/ buffers.
" TODO: ends up in wrong buffer when any buffers had unwritten changes and did
" not delete (or floaterm buffer was in background)
nmap <leader>Q :%bd<cr>\|:e#<cr>\|:bd#<cr>

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
if has('win32')
    colorscheme molokai
else
    "colorscheme strange
    colorscheme BusyBee
    "colorscheme molokai
    "colorscheme fine_blue
    "colorscheme pyte
endif

syntax enable

" misc {{{1

source $MYVIMDIR/abbreviations.vim

" Esc alternative (easy on Dvorak)
inoremap hh <Esc>

" todo.txt additional bindings
augroup todotxtgroup
    autocmd!
    autocmd BufNewFile,BufRead,BufEnter todo.txt so $MYVIMDIR/todo-extra.vim
augroup END

" other
autocmd Filetype gtd setlocal fdm=indent

"hi ColorColumn guibg=#330000 ctermbg=Black

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
