" Maciej's Vim setup
"
" Version-controlled here:
"   https://github.com/maciekk/vimrc

" TODO:
" - why upon start is there always an empty buffer, in addition to buffers
"   from last session?
" - why is BufExplorer slow to update screen when you press 'd' to delete
"   buffer?
" - why on restart does MacVim not reopen last view? need mksession?

" Choose better leaders.
let mapleader = " "
let maplocalleader = ","

" First, some mappings to work with this config file.
nnoremap <Leader>ve :vsplit ~/.vim/vimrc<cr>
nnoremap <Leader>vs :so $MYVIMRC<cr>
nnoremap <Leader>vp :so $MYVIMRC<cr>\|:PlugClean<cr>\|:PlugInstall<cr>

" initial setup {{{1
set nocompatible               " be iMproved

if has ('win32')
    let $MYVIMDIR="~/vimfiles"
else
    let $MYVIMDIR="~/.vim"
endif
set runtimepath+=$MYVIMDIR

call plug#begin('~/.vim/plugged')

" plugins {{{1

let $PLUGDIR=$MYVIMDIR.'/plugins'

Plug 'junegunn/vim-plug'

" fancy startup page
"Plug 'mhinz/vim-startify'

" fundamentals {{{2
so $PLUGDIR/verbs-n-nouns.vim
so $PLUGDIR/undo.vim
so $PLUGDIR/matchit.vim
so $PLUGDIR/narrow.vim

" conveniences {{{2
so $PLUGDIR/ctrlp.vim
"so $PLUGDIR/snippets.vim
Plug 'romainl/vim-cool'
Plug 'tpope/vim-obsession'
Plug 'junegunn/vim-peekaboo'
Plug 'thinca/vim-fontzoom'
Plug 'airblade/vim-rooter'
"let g:rooter_patterns = ['.git', '>~']
let g:rooter_patterns = ['>~']

" tools {{{2
so $PLUGDIR/nerd.vim
so $PLUGDIR/git.vim
so $PLUGDIR/markdown.vim
so $PLUGDIR/wiki.vim
so $PLUGDIR/floaterm.vim
so $PLUGDIR/notes.vim
"so $PLUGDIR/outliners.vim
"so $PLUGDIR/org.vim
Plug 'jlanzarotta/bufexplorer'
"Plug 'mileszs/ack.vim'

" languages {{{2
Plug 'mattn/emmet-vim'  " HTML
"Plug 'fatih/vim-go'

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
"Plug 'FuzzyFinder'
"Plug 'techlivezheng/vim-plugin-minibufexpl'
"Plug 'taglist.vim'  " superseded by 'tagbar'?

" suggested by YouCompleteMe (corp)
"Plug 'scrooloose/syntastic'

" cemetary: no longer used
"Plug 'kien/tabman.vim'
"Plug 'freitass/todo.txt-vim'

" All of your Plugins must be added before the following line
call plug#end()

" settings {{{1
set backspace=indent,eol,start
set encoding=utf-8
set hidden
set history=999
set incsearch
set matchpairs+=<:>

" content display
set foldlevelstart=0
set list
set listchars=tab:»·,trail:·,extends:»,precedes:«

" history persistence
set undofile
set viminfo='100,<50,s10,h,%

" window treatments
set splitbelow
set splitright
set diffopt+=vertical

" status-related
set cmdheight=1
set laststatus=2
set modeline
set ruler
set shortmess+=I
set showcmd
set showmatch
set showmode

" Scrolling
set scrolloff=4
set sidescrolloff=4

" Line numbers
set number
set relativenumber

" Tabs & similar
set expandtab
set tabstop=4
set shiftwidth=4

" wild settings
set wildmenu
set wildmode=list:longest,full
set wildoptions=fuzzy,pum

" paths
set path=.,**  " where to search for files when using 'gf' et al
set directory=~/tmp,/var/tmp/,/tmp,.  " swap file locations
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

" List of favourite themes:
"   - BusyBee
"   - molokai
"   - gruvbox
"   - pyte
"   - fine_blue
"   - fu
"   - inkstained
"   - strange
"   - toast
"   - melange
"   - sonokai
"   - candy

set bg=dark
colorscheme gruvbox
"colorscheme strange
"colorscheme BusyBee
"colorscheme molokai
"colorscheme fine_blue
"colorscheme pyte

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
